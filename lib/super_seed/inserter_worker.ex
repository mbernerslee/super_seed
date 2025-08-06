defmodule SuperSeed.InserterWorker do
  use GenServer
  require Logger

  def start_link(inserter, repo, server_pid) do
    GenServer.start_link(__MODULE__, {inserter, repo, server_pid}, name: inserter)
  end

  def init({inserter, repo, server_pid}) do
    {:ok, %{status: :pending, server_pid: server_pid, inserter: inserter, repo: repo}}
  end

  def handle_cast({:run_requested, results}, %{status: :pending} = state) do
    {:noreply, %{state | status: :running}, {:continue, {:run, results}}}
  end

  def handle_cast({:run_requested, _results}, state) do
    {:noreply, state}
  end

  def handle_continue({:run, results}, state) do
    Logger.debug("#{inspect(state.inserter)} running...")
    %{repo: repo, inserter: inserter, server_pid: server_pid} = state

    # TODO test errors being caught & handled properly
    result =
      try do
        repo.transaction(fn -> inserter.insert(results) end)
      rescue
        error ->
          Logger.debug("#{inspect(state.inserter)} error: #{inspect(error)}")
          {:error, error}
      end

    Logger.debug("#{inspect(state.inserter)} finished!")

    :ok = GenServer.cast(server_pid, {:worker_finished, inserter, result})

    {:stop, :normal, %{state | status: :finished}}
  end
end
