defmodule SuperSeed.Server do
  require Logger
  use GenServer
  alias SuperSeed.DependencyResolver
  alias SuperSeed.InserterWorker
  alias SuperSeed.InserterWorkersStatus
  alias SuperSeed.WhichInsertersCanRun

  # TODO add more mix tasks e.g. inserter generation
  # TODO    - super_seed.init (adds to config? creates
  # TODO    - super_seed.gen.inserter (creates new inserter)
  # TODO    - super_seed.tree (shows visual deps tree)
  # TODO do a sweep of test coverage
  # TODO ensure it works in dev / prod?
  # TODO update README.md
  def run(repo, inserters) do
    GenServer.start_link(__MODULE__, %{repo: repo, inserters: inserters, caller_pid: self()}, name: __MODULE__)
  end

  def init(%{inserters: [], caller_pid: caller_pid}) do
    Logger.info("#{__MODULE__} - exiting on startup because no Inserters modules found")
    send(caller_pid, :server_done)
    :ignore
  end

  def init(%{repo: repo, inserters: inserters, caller_pid: caller_pid}) do
    Logger.info("#{__MODULE__} - starting")

    expended_inserters =
      Enum.map(inserters, fn inserter -> {inserter, inserter.table(), inserter.depends_on()} end)

    deps = DependencyResolver.resolve(expended_inserters)

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
    case InserterWorkersStatus.determine(state.workers) do
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
end
