defmodule SuperSeed.InitTest do
  use ExUnit.Case, async: true
  use Mimic
  alias SuperSeed.Init
  alias SuperSeed.SideEffectsWrapper

  describe "run/1" do
    test "given no arguments, uses default inserter group" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        [
          {:default_inserter_group, :example_name},
          {:inserter_groups,
           %{
             example_name: %{
               namespace: SuperSeed.Support.Inserters.ValidationExamples,
               repo: ExampleNamespace.Repo,
               app: :example_app
             }
           }}
        ]
      end)

      Mimic.expect(SideEffectsWrapper, :application_get_key, 1, fn :example_app, :modules ->
        {:ok,
         [
           SuperSeed.Support.Inserters.ValidationExamples.MinimumValid,
           OtherNamespace.IgnoredModule
         ]}
      end)

      Mimic.expect(SideEffectsWrapper, :application_ensure_all_started, 1, fn :example_app ->
        {:ok, []}
      end)

      assert {:ok,
              %{
                inserters: [SuperSeed.Support.Inserters.ValidationExamples.MinimumValid],
                repo: ExampleNamespace.Repo
              }} == Init.run()
    end

    test "given an inserter name that exists in config, we load the modules under its namespace" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        [
          {:inserter_groups,
           %{
             example_name: %{
               namespace: SuperSeed.Support.Inserters.ValidationExamples,
               repo: ExampleNamespace.Repo,
               app: :example_app
             }
           }}
        ]
      end)

      Mimic.expect(SideEffectsWrapper, :application_get_key, 1, fn :example_app, :modules ->
        {:ok,
         [
           SuperSeed.Support.Inserters.ValidationExamples.MinimumValid,
           OtherNamespace.IgnoredModule
         ]}
      end)

      Mimic.expect(SideEffectsWrapper, :application_ensure_all_started, 1, fn :example_app ->
        {:ok, []}
      end)

      assert {:ok,
              %{
                inserters: [SuperSeed.Support.Inserters.ValidationExamples.MinimumValid],
                repo: ExampleNamespace.Repo
              }} == Init.run(:example_name)
    end

    @tag :capture_log
    test "when there's no config under the given name, return error" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        nil
      end)

      Mimic.reject(&SideEffectsWrapper.application_get_key/2)
      Mimic.reject(&SideEffectsWrapper.application_ensure_all_started/1)

      assert {:error, {:init, :missing_config}} = Init.run(:example_name)
    end

    @tag :capture_log
    test "when the config doesn't have the expected structure, return error" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        "wrong format"
      end)

      Mimic.reject(&SideEffectsWrapper.application_get_key/2)
      Mimic.reject(&SideEffectsWrapper.application_ensure_all_started/1)

      assert {:error, {:init, :config_in_wrong_format}} = Init.run(:example_name)
    end

    @tag :capture_log
    test "when reading modules fails, return error" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        [
          {:inserter_groups,
           %{
             example_name: %{
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

      Mimic.reject(&SideEffectsWrapper.application_ensure_all_started/1)

      assert {:error, {:init, :inserter_modules_not_found}} = Init.run(:example_name)
    end

    @tag :capture_log
    test "when inserter group is not found in config, return error" do
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

      Mimic.reject(&SideEffectsWrapper.application_get_key/2)
      Mimic.reject(&SideEffectsWrapper.application_ensure_all_started/1)

      assert {:error, {:init, :inserter_group_not_found}} = Init.run(:missing_group)
    end

    test "errors when the app is not started" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        [
          {:default_inserter_group, :example_name},
          {:inserter_groups,
           %{
             example_name: %{
               namespace: SuperSeed.Support.Inserters.ValidationExamples,
               repo: ExampleNamespace.Repo,
               app: :example_app
             }
           }}
        ]
      end)

      Mimic.expect(SideEffectsWrapper, :application_get_key, 1, fn :example_app, :modules ->
        {:ok,
         [
           SuperSeed.Support.Inserters.ValidationExamples.MinimumValid,
           OtherNamespace.IgnoredModule
         ]}
      end)

      Mimic.expect(SideEffectsWrapper, :application_ensure_all_started, 1, fn :example_app ->
        {:error, {:example_app, :fail}}
      end)

      assert {:error, {:init, :app_not_started, :example_app}} == Init.run()
    end

    @tag :capture_log
    test "when default inserter group is not found in config, return error" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        [
          {:default_inserter_group, :missing_group},
          {:inserter_groups,
           %{
             example_name: %{
               namespace: ExampleNamespace,
               repo: ExampleNamespace.Repo,
               app: :example_app
             }
           }}
        ]
      end)

      Mimic.reject(&SideEffectsWrapper.application_get_key/2)
      Mimic.reject(&SideEffectsWrapper.application_ensure_all_started/1)

      assert {:error, {:init, :default_inserter_group_not_found}} = Init.run()
    end

    @tag :capture_log
    test "when inserter module validation fails, return error" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        [
          {:inserter_groups,
           %{
             example_name: %{
               namespace: SuperSeed.Support.Inserters.ValidationExamples,
               repo: ExampleNamespace.Repo,
               app: :example_app
             }
           }}
        ]
      end)

      invalid_module = SuperSeed.Support.Inserters.ValidationExamples.MissingInsert

      Mimic.expect(SideEffectsWrapper, :application_get_key, 1, fn :example_app, :modules ->
        {:ok, [invalid_module]}
      end)

      Mimic.expect(SideEffectsWrapper, :application_ensure_all_started, 1, fn :example_app ->
        {:ok, []}
      end)

      assert {:error, {:inserter_module_validation, invalid_module, :malformed}} ==
               Init.run(:example_name)
    end
  end
end
