defmodule SuperSeed.InserterWorkerTest do
  use SuperSeed.Support.DataCase, async: true
  alias SuperSeed.InserterWorker
  alias SuperSeed.Repo
  alias SuperSeed.Support.Inserters.Farming.Farms.SunriseValley
  alias SuperSeed.Support.Schemas.Farm

  test "workers whose DB operations succeed work ok" do
    assert {:ok, pid} = InserterWorker.start_link(SunriseValley, Repo, self())
    Ecto.Adapters.SQL.Sandbox.allow(Repo, self(), pid)

    assert %{
             status: :pending,
             repo: Repo,
             inserter: SunriseValley,
             server_pid: self()
           } == :sys.get_state(pid)

    GenServer.cast(pid, {:run_requested, %{}})

    assert_receive {:"$gen_cast", {:worker_finished, SunriseValley, {:ok, _}}}, 500

    assert [%Farm{name: "Sunrise Valley"}] = Repo.all(Farm)
  end

  defmodule RaisingInserter do
    def table, do: "farms"
    def depends_on, do: []

    def insert(_) do
      raise "no!"
    end
  end

  @tag capture_log: true
  test "workers that raise are handled gracefully" do
    assert {:ok, pid} = InserterWorker.start_link(RaisingInserter, Repo, self())

    GenServer.cast(pid, {:run_requested, %{}})

    assert_receive {:"$gen_cast", {:worker_finished, RaisingInserter, {:error, %RuntimeError{message: "no!"}}}}, 500
  end
end
