defmodule Mix.Tasks.SuperSeed.Gen.InserterTest do
  use ExUnit.Case, async: true
  use Mimic
  alias SuperSeed.SideEffectsWrapper
  alias Mix.Tasks.SuperSeed.Gen.Inserter

  describe "run/1" do
    test "with no args, creates new inserter file for default inserter group" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        [
          {:default_inserter_group, :example_name},
          {:inserter_groups,
           %{
             example_name: %{
               namespace: MyApp.SuperSeed,
               repo: ExampleNamespace.Repo,
               app: :example_app
             }
           }}
        ]
      end)

      assert :ok == Inserter.run()

      # \
      # |
    end

    # name |> Init.run() |> run_server()
  end
end
