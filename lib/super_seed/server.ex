defmodule SuperSeed.Server do
  require Logger
  use GenServer
  alias SuperSeed.InserterWorker
  alias SuperSeed.WhichInsertersCanRun

  # TODO work out what level of stuff to test at this level vs the functionally pure part
  # TODO do a sweep of test coverage
  # TODO add credo rules. audit them & maybe make a separate repo containing the preferred set?
  # TODO ensure it works in dev / prod?
  # TODO update README.md
  # TODO add more mix tasks e.g. inserter generation
  # TODO add fuller inserter validation e.g. circular dependencies etc etc
  def run(repo, inserters) do
    GenServer.start_link(__MODULE__, %{repo: repo, inserters: inserters, caller_pid: self()}, name: __MODULE__)
  end

  def init(%{inserters: [], caller_pid: caller_pid}) do
    send(caller_pid, :server_done)
    :ignore
  end

  def init(%{repo: repo, inserters: inserters, caller_pid: caller_pid}) do
    Logger.info("#{__MODULE__} - starting")
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
    Logger.debug("#{__MODULE__} - #{inserter} worker finished")

    state =
      state
      |> put_in([:workers, inserter, :status], :finished)
      |> put_in([:results, inserter], result)

    continue_or_exit(state)
  end

  def handle_cast({:worker_finished, inserter, {:error, error}}, state) do
    Logger.error("#{__MODULE__} - #{inserter} error #{inspect({:error, error})}")

    state =
      state
      |> put_in([:workers, inserter, :status], :error)
      |> put_in([:results, inserter], {:error, error})

    workers =
      Map.new(state.workers, fn
        {inserter, %{pid: pid, status: :pending}} ->
          Logger.debug("#{__MODULE__} - #{inserter} halting")
          :ok = GenServer.stop(pid, :normal)
          {inserter, %{pid: pid, status: :halted}}

        {inserter, worker} ->
          {inserter, worker}
      end)

    state = %{state | workers: workers}

    continue_or_exit(state)
  end

  defp continue_or_exit(state) do
    case worker_status(state) do
      {:finished, :ok} ->
        Logger.info("#{__MODULE__} - finished ok!")
        send(state.caller_pid, :server_done)
        {:stop, :normal, state}

      {:finished, :error} ->
        Logger.error("#{__MODULE__} - finished in error")
        send(state.caller_pid, :server_error)
        {:stop, :normal, state}

      :running ->
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

  # TODO extact and test this
  defp worker_status(state) do
    Enum.reduce_while(state.workers, {:finished, :ok}, fn
      {_, %{status: :pending}}, _ -> {:halt, :running}
      {_, %{status: :running}}, _ -> {:halt, :running}
      {_, %{status: :halted}}, _ -> {:cont, {:finished, :error}}
      {_, %{status: :error}}, _ -> {:cont, {:finished, :error}}
      {_, %{status: :finished}}, acc -> {:cont, acc}
    end)
  end

  # TODO extact and test this. keep keep the Enum.map here, but the other fnal logic out (so the tests not need to be given modules, just data)
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
