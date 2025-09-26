defmodule SuperSeed.ServerTest do
  use SuperSeed.Support.DataCase, async: false
  use Mimic
  import Ecto.Query

  alias SuperSeed.Repo
  alias SuperSeed.Server
  alias SuperSeed.Support.Assertions

  setup :set_mimic_global

  defmodule PostgresErrorFarmInserter do
    @behaviour SuperSeed.Inserter
    alias SuperSeed.Repo

    @impl true
    def table, do: "animals"

    @impl true
    def depends_on, do: [{:table, "animal_types"}]

    @impl true
    def insert(_) do
      Repo.query("SELECT * FROM nonexistent_table")
    end
  end

  defmodule DepsOrderingTest do
    defmodule A1 do
      @behaviour SuperSeed.Inserter
      @impl true
      def table, do: "a"

      @impl true
      def depends_on, do: []

      @impl true
      def insert(_) do
        receive do
          :finish ->
            {:ok, "a1"}
        end
      end
    end

    defmodule A2 do
      @behaviour SuperSeed.Inserter
      @impl true
      def table, do: "a"

      @impl true
      def depends_on, do: []

      @impl true
      def insert(_) do
        receive do
          :finish ->
            {:ok, "a2"}
        end
      end
    end

    defmodule B1 do
      @behaviour SuperSeed.Inserter
      @impl true
      def table, do: "b"

      @impl true
      def depends_on, do: [{:inserter, DepsOrderingTest.A1}]

      @impl true
      def insert(_) do
        receive do
          :finish ->
            {:ok, "b1"}
        end
      end
    end

    defmodule B2 do
      @behaviour SuperSeed.Inserter
      alias SuperSeed.Repo

      @impl true
      def table, do: "b"

      @impl true
      def depends_on, do: [{:table, "a"}]

      @impl true
      def insert(_) do
        receive do
          :finish ->
            {:ok, "b2"}
        end
      end
    end
  end

  describe "run/2" do
    test "when inserters = [], we immediately quit" do
      assert :ignore = Server.run(Repo, [])
      assert_receive :server_done
    end

    test "works with only 1 inserter module whose depends_on = [], we run it" do
      assert {:ok, _pid} = Server.run(Repo, [SuperSeed.Support.Inserters.Farming.Farms.SunriseValley])
      assert_receive :server_done, 1_000

      assert Repo.one!(from(f in "farms", select: f.name)) == "Sunrise Valley"
    end

    test "with all ':farm' inserters, we perform all expected DB inserters" do
      {:ok, modules} = :application.get_key(:super_seed, :modules)

      farming_inserters =
        Enum.filter(modules, fn module ->
          String.starts_with?(to_string(module), "Elixir.SuperSeed.Support.Inserters.Farming.")
        end)

      assert {:ok, _} = Server.run(Repo, farming_inserters)
      assert_receive :server_done, 1_000

      Assertions.assert_farm_inserter_group_db_inserts()
    end

    @tag :capture_log
    test "with all ':farm' inserters, but one inserter that fails towards the end, return error" do
      {:ok, modules} = :application.get_key(:super_seed, :modules)

      farming_inserters =
        Enum.filter(modules, fn module ->
          String.starts_with?(to_string(module), "Elixir.SuperSeed.Support.Inserters.Farming.")
        end)

      farming_inserters = [PostgresErrorFarmInserter | farming_inserters]

      Server.run(Repo, farming_inserters)

      assert_receive :server_error, 1_000
    end

    # For some reason this test has flakey DB connection issues.
    # Mocking the DB for this 1 test makes it stable & we can still test the logic, which is the point of this test
    test "run order respects dependencies" do
      inserters = [
        DepsOrderingTest.A1,
        DepsOrderingTest.A2,
        DepsOrderingTest.B1,
        DepsOrderingTest.B2
      ]

      Mimic.expect(Repo, :transaction, length(inserters), fn fun -> fun.() end)

      assert {:ok, server_pid} = Server.run(Repo, inserters)

      assert %{
               workers: %{
                 DepsOrderingTest.A1 => %{
                   pid: a1_pid,
                   status: :running
                 },
                 DepsOrderingTest.A2 => %{
                   pid: a2_pid,
                   status: :running
                 },
                 DepsOrderingTest.B1 => %{
                   pid: b1_pid,
                   status: :pending
                 },
                 DepsOrderingTest.B2 => %{
                   pid: b2_pid,
                   status: :pending
                 }
               },
               deps: deps,
               results: %{}
             } = :sys.get_state(server_pid)

      assert deps == %{
               DepsOrderingTest.A1 => MapSet.new([]),
               DepsOrderingTest.A2 => MapSet.new([]),
               DepsOrderingTest.B2 => MapSet.new([DepsOrderingTest.A1, DepsOrderingTest.A2]),
               DepsOrderingTest.B1 => MapSet.new([DepsOrderingTest.A1])
             }

      send(a1_pid, :finish)

      Assertions.retry_assertion_fn(fn ->
        assert %{
                 workers: %{
                   DepsOrderingTest.A1 => %{
                     status: :finished
                   },
                   DepsOrderingTest.A2 => %{
                     status: :running
                   },
                   DepsOrderingTest.B1 => %{
                     status: :running
                   },
                   DepsOrderingTest.B2 => %{
                     status: :pending
                   }
                 },
                 results: %{DepsOrderingTest.A1 => "a1"}
               } = :sys.get_state(server_pid)
      end)

      send(a2_pid, :finish)

      Assertions.retry_assertion_fn(fn ->
        assert %{
                 workers: %{
                   DepsOrderingTest.A1 => %{
                     status: :finished
                   },
                   DepsOrderingTest.A2 => %{
                     status: :finished
                   },
                   DepsOrderingTest.B1 => %{
                     status: :running
                   },
                   DepsOrderingTest.B2 => %{
                     status: :running
                   }
                 },
                 results: %{
                   DepsOrderingTest.A1 => "a1",
                   DepsOrderingTest.A2 => "a2"
                 }
               } = :sys.get_state(server_pid)
      end)

      send(b1_pid, :finish)

      Assertions.retry_assertion_fn(fn ->
        assert %{
                 workers: %{
                   DepsOrderingTest.A1 => %{
                     status: :finished
                   },
                   DepsOrderingTest.A2 => %{
                     status: :finished
                   },
                   DepsOrderingTest.B1 => %{
                     status: :finished
                   },
                   DepsOrderingTest.B2 => %{
                     status: :running
                   }
                 },
                 results: %{
                   DepsOrderingTest.A1 => "a1",
                   DepsOrderingTest.A2 => "a2",
                   DepsOrderingTest.B1 => "b1"
                 }
               } = :sys.get_state(server_pid)
      end)

      send(b2_pid, :finish)

      assert_receive :server_done, 1_000
    end
  end
end
