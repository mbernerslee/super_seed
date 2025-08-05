defmodule Mix.Tasks.SuperSeedTest do
  # @moduledoc "Aync false because DB opertaions happening in many processes"
  use SuperSeed.Support.DataCase, async: false
  use Mimic
  import Ecto.Query

  alias SuperSeed.Repo
  alias SuperSeed.Support.Mocks
  alias SuperSeed.SideEffectsWrapper

  @doc """
  use_real_config/0 uses the config defined in config/test.exs
  """
  describe "run/1" do
    test "given an inserter_group name, runs it" do
      Mocks.use_real_config()
      assert :ok == Mix.Tasks.SuperSeed.run([:farms])

      assert Repo.all(from a in "farms", select: a.name) == ["Sunrise Valley"]
    end

    test "given a different inserter_group name, runs it" do
      Mocks.use_real_config()
      assert :ok == Mix.Tasks.SuperSeed.run([:simple_example])
    end

    test "when a default_inserter_group is defined" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        [
          {:default_inserter_group, :first_group},
          {:inserters,
           %{
             first_group: %{
               namespace: FirstExample,
               repo: FirstExample.Repo,
               app: :example_app
             },
             second_group: %{
               namespace: SecondExample,
               repo: SecondExample.Repo,
               app: :example_app
             }
           }}
        ]
      end)

      Mimic.expect(SideEffectsWrapper, :application_get_key, 1, fn :example_app, :modules ->
        {:ok, [SuperSeed.Support.Inserters.SimpleExample.FirstSuper, Seed.Support.Inserters.SimpleExample.First]}
      end)

      assert :ok == Mix.Tasks.SuperSeed.run([])

      # raise "no"
    end
  end
end

# TODO rollback everything if any inserter fails
