defmodule SuperSeedTest do
  # @moduledoc "Aync false because DB opertaions happening in many processes"
  use SuperSeed.Support.DataCase, async: false
  use Mimic
  alias SuperSeed.SideEffectsWrapper
  alias SuperSeed.Support.Assertions
  alias SuperSeed.Support.Mocks

  describe "run/1 - happy paths" do
    test "given an inserter group atom, run the inserter" do
      Mocks.use_real_config()
      assert :ok == SuperSeed.run(:farms)

      Assertions.assert_farm_inserter_group_db_inserts()
    end

    test "given an different inserter group atom, run the inserter" do
      Mocks.use_real_config()
      assert :ok == SuperSeed.run(:simple_example)

      Assertions.assert_simple_example_inserter_group_db_inserts()
    end

    test "given an no inserter group, run the default inserter group when it exists" do
      Mocks.use_real_config()
      assert :ok == SuperSeed.run()

      Assertions.assert_farm_inserter_group_db_inserts()
    end
  end

  describe "run/1 - error cases" do
    @tag :capture_log
    test "when inserter modules are not found, returns error" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        [
          {:inserter_groups,
           %{
             example_inserter_group_name: %{
               namespace: ExampleNamespace,
               repo: ExampleNamespace.Repo,
               app: :example_app
             }
           }}
        ]
      end)

      Mimic.expect(SideEffectsWrapper, :application_get_key, 1, fn :example_app, :modules ->
        :undefined
      end)

      assert {:error, {:init, :inserter_modules_not_found}} = SuperSeed.run(:example_inserter_group_name)
    end

    @tag :capture_log
    test "when config is in wrong format, returns error" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        "wrong format"
      end)

      assert {:error, {:init, :config_in_wrong_format}} = SuperSeed.run(:example_inserter_group_name)
    end

    @tag :capture_log
    test "when config is missing, returns error" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        nil
      end)

      assert {:error, {:init, :missing_config}} = SuperSeed.run(:example_inserter_group_name)
    end

    @tag :capture_log
    test "when inserter group is not found in config, returns error" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        [
          {:inserter_groups,
           %{
             different_group: %{
               namespace: ExampleNamespace,
               repo: ExampleNamespace.Repo,
               app: :example_app
             }
           }}
        ]
      end)

      assert {:error, {:init, :inserter_group_not_found}} = SuperSeed.run(:missing_group)
    end

    @tag :capture_log
    test "when default inserter group is not found in config, returns error" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        [
          {:default_inserter_group, :missing_default_group},
          {:inserter_groups,
           %{
             available_group: %{
               namespace: ExampleNamespace,
               repo: ExampleNamespace.Repo,
               app: :example_app
             }
           }}
        ]
      end)

      assert {:error, {:init, :default_inserter_group_not_found}} = SuperSeed.run()
    end

    @tag :capture_log
    test "when inserter module validation fails, returns error" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        [
          {:inserter_groups,
           %{
             example_inserter_group_name: %{
               namespace: SuperSeed.Support.Inserters.ValidationExamples,
               repo: SuperSeed.Repo,
               app: :super_seed
             }
           }}
        ]
      end)

      Mimic.expect(SideEffectsWrapper, :application_get_key, 1, fn :super_seed, :modules ->
        {:ok, [SuperSeed.Support.Inserters.ValidationExamples.MissingInsert]}
      end)

      assert {:error,
              {:inserter_module_validation, SuperSeed.Support.Inserters.ValidationExamples.MissingInsert, :malformed}} =
               SuperSeed.run(:example_inserter_group_name)
    end

    @tag :capture_log
    test "when a worker fails during execution, returns server error" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        [
          {:inserter_groups,
           %{
             test_group: %{
               namespace: SuperSeed.Support.Inserters.ValidationExamples,
               repo: SuperSeed.Repo,
               app: :super_seed
             }
           }}
        ]
      end)

      Mimic.expect(SideEffectsWrapper, :application_get_key, 1, fn :super_seed, :modules ->
        {:ok, [SuperSeed.Support.Inserters.ValidationExamples.CausesError]}
      end)

      assert {:error, :inserter} == SuperSeed.run(:test_group)
    end
  end
end
