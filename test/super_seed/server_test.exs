defmodule SuperSeed.ServerTest do
  use SuperSeed.Support.DataCase, async: false
  import Ecto.Query

  alias SuperSeed.Repo
  alias SuperSeed.Server
  alias SuperSeed.Support.Assertions

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

  describe "run/2" do
    test "when inserters = [], we immediately quit" do
      assert :ignore = Server.run(SuperSeed.Repo, [])
      assert_receive :server_done
    end

    test "works with only 1 inserter module when inserters = [], we immediately quit" do
      assert {:ok, _pid} = Server.run(SuperSeed.Repo, [SuperSeed.Support.Inserters.Farming.Farms.SunriseValley])
      assert_receive :server_done

      assert Repo.one!(from(f in "farms", select: f.name)) == "Sunrise Valley"
    end

    test "with all ':farm' inserters, we perform all expected DB inserters" do
      {:ok, modules} = :application.get_key(:super_seed, :modules)

      farming_inserters =
        Enum.filter(modules, fn module ->
          String.starts_with?(to_string(module), "Elixir.SuperSeed.Support.Inserters.Farming.")
        end)

      assert {:ok, _} = Server.run(SuperSeed.Repo, farming_inserters)
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

      Server.run(SuperSeed.Repo, farming_inserters)

      assert_receive :server_error, 1_000
    end
  end
end
