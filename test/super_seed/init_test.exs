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
               namespace: ExampleNamespace,
               repo: ExampleNamespace.Repo,
               app: :example_app
             }
           }}
        ]
      end)

      Mimic.expect(SideEffectsWrapper, :application_get_key, 1, fn :example_app, :modules ->
        {:ok,
         [
           ExampleNamespace.FakeModule,
           OtherNamespace.IgnoredModule,
           ExampleNamespace.OtherFakeModule
         ]}
      end)

      assert {:ok,
              %{
                inserters: [ExampleNamespace.FakeModule, ExampleNamespace.OtherFakeModule],
                repo: ExampleNamespace.Repo,
                app: :example_app
              }} == Init.run()
    end

    test "given an inserter name that exists in config, we load the modules under its namespace" do
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
        {:ok,
         [
           ExampleNamespace.FakeModule,
           OtherNamespace.IgnoredModule,
           ExampleNamespace.OtherFakeModule
         ]}
      end)

      assert {:ok,
              %{
                inserters: [ExampleNamespace.FakeModule, ExampleNamespace.OtherFakeModule],
                repo: ExampleNamespace.Repo,
                app: :example_app
              }} == Init.run(:example_name)
    end

    @tag :capture_log
    test "when there's no config under the given name, return error" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        nil
      end)

      Mimic.reject(&SideEffectsWrapper.application_get_key/2)

      assert {:error, {:init, :missing_config}} = Init.run(:example_name)
    end

    @tag :capture_log
    test "when the config doesn't have the expected structure, return error" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        "wrong format"
      end)

      Mimic.reject(&SideEffectsWrapper.application_get_key/2)

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

      assert {:error, {:init, :inserter_group_not_found}} = Init.run(:missing_group)
    end

    @tag :capture_log
    test "when default inserter group is not found in config, return error" do
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

      assert {:error, {:init, :default_inserter_group_not_found}} = Init.run()
    end

    test "module filtering works with module names prefixed with Elixir" do
      Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
        Application.get_all_env(:super_seed)
      end)

      Mimic.expect(SideEffectsWrapper, :application_get_key, 1, fn :super_seed, :modules ->
        {:ok, modules} = :application.get_key(:super_seed, :modules)
        {:ok, [Elixir.SuperSeed.Support.Inserters.Farming.TestModule | modules]}
      end)

      assert {:ok, %{inserters: inserters, repo: SuperSeed.Repo}} = Init.run(:farms)

      assert Enum.member?(inserters, Elixir.SuperSeed.Support.Inserters.Farming.TestModule)
      assert Enum.member?(inserters, SuperSeed.Support.Inserters.Farming.TestModule)
      assert Enum.member?(inserters, SuperSeed.Support.Inserters.Farming.Farms.SunriseValley)
    end
  end
end
