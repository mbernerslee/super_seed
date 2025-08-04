defmodule SuperSeed.Server do
  require Logger
  use GenServer
  alias SuperSeed.InserterWorker
  alias SuperSeed.WhichInsertersCanRun

  def run(repo, inserters) do
    {:ok, _server_pid} =
      GenServer.start_link(__MODULE__, %{repo: repo, inserters: inserters, caller_pid: self()})
  end

  def init(%{repo: repo, inserters: inserters, caller_pid: caller_pid}) do
    deps = build_dependencies(inserters)

    workers =
      Map.new(inserters, fn inserter ->
        {:ok, worker_pid} = InserterWorker.start_link(inserter, repo, self())
        {inserter, %{status: :pending, pid: worker_pid}}
      end)

    {:ok, %{repo: repo, workers: workers, deps: deps, results: %{}, caller_pid: caller_pid}, {:continue, :start}}
  end

  def handle_continue(:start, state) do
    {:noreply, start_workers_which_can_run(state)}
  end

  def handle_cast({:worker_finished, inserter, {:ok, result}}, state) do
    state =
      state
      |> put_in([:workers, inserter, :status], :finished)
      |> put_in([:results, inserter], result)

    # TODO BUG was here!!! never fininshed because only checking status BEFORE we update dthe last one. write a test to catch this
    if Enum.all?(state.workers, fn {_, %{status: status}} -> status == :finished end) do
      Logger.debug("Server - DONE!")
      send(state.caller_pid, :server_done)
      {:stop, :normal, state}
    else
      {:noreply, start_workers_which_can_run(state)}
    end
  end

  defp start_workers_which_can_run(state) do
    %{deps: deps, workers: workers, results: results} = state

    deps
    |> WhichInsertersCanRun.determine(workers)
    |> Enum.reduce(state, fn inserter, state ->
      worker = state[:workers][inserter]
      worker = Map.replace!(worker, :status, :running)

      GenServer.cast(worker.pid, {:run_requested, results})

      put_in(state, [:workers, inserter], worker)
    end)
  end

  defp build_dependencies(inserters) do
    expended =
      Enum.map(inserters, fn inserter -> {inserter, inserter.table(), inserter.depends_on()} end)

    tables =
      Enum.reduce(expended, %{}, fn {inserter, table, _depends_on}, acc ->
        Map.update(acc, table, [inserter], &[inserter | &1])
      end)

    Map.new(expended, fn {inserter, _table, depends_on} ->
      dependants =
        depends_on
        |> Enum.flat_map(fn
          {:table, table} -> Map.fetch!(tables, table)
          {:inserter, inserter} -> [inserter]
        end)
        |> MapSet.new()

      {inserter, dependants}
    end)
  end
end
