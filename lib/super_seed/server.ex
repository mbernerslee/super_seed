defmodule SuperSeed.Server do
  use GenServer
  alias SuperSeed.WhichInsertersCanRun

  def run(repo, inserters) do
    {:ok, _server_pid} =
      GenServer.start_link(__MODULE__, %{repo: repo, inserters: inserters, caller_pid: self()})

    # repo.transaction(fn ->
    #  Enum.each(inserters, fn inserter -> inserter.insert(:ok) end)
    # end)

    send(self(), :server_done)
  end

  def init(%{repo: repo, inserters: inserters, caller_pid: caller_pid}) do
    dependencies = build_dependencies(inserters)
    statuses = Map.new(inserters, fn inserter -> {inserter, :pending} end)

    WhichInsertersCanRun.determine(dependencies, statuses)
    |> IO.inspect()

    {:ok, %{repo: repo, statuses: statuses, finished: %{}, caller_pid: caller_pid},
     {:continue, :start}}
  end

  def handle_continue(:start, state) do
    {:noreply, state}
  end

  defp build_dependencies(inserters) do
    expended =
      Enum.map(inserters, fn inserter -> {inserter, inserter.table(), inserter.depends_on()} end)

    tables =
      Enum.reduce(expended, %{}, fn {inserter, table, depends_on}, acc ->
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
