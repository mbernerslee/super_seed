defmodule SuperSeed.InitTest do
  use ExUnit.Case, async: true
  use Mimic
  alias SuperSeed.Init
  alias SuperSeed.SideEffectsWrapper

  describe "run/1" do
    test "given an inserter name that exists in config, we load the modules under its namespace" do
      Mimic.expect(SideEffectsWrapper, :application_get_env, 1, fn :super_seed, :inserters ->
        %{
          example_name: %{
            namespace: ExampleNamespace,
            repo: ExampleNamespace.Repo,
            app: :example_app
          }
        }
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
                modules: [ExampleNamespace.FakeModule, ExampleNamespace.OtherFakeModule],
                repo: ExampleNamespace.Repo
              }} ==
               Init.run(:example_name)
    end

    @tag :capture_log
    test "when there's no config under the given name, return error" do
      Mimic.expect(SideEffectsWrapper, :application_get_env, 1, fn :super_seed, :inserters ->
        nil
      end)

      Mimic.reject(&SideEffectsWrapper.application_get_key/2)

      assert {:error, {:init, :missing_config}} = Init.run(:example_name)
    end

    @tag :capture_log
    test "when the config doesn't have the expected structure, return error" do
      Mimic.expect(SideEffectsWrapper, :application_get_env, 1, fn :super_seed, :inserters ->
        "wrong format"
      end)

      Mimic.reject(&SideEffectsWrapper.application_get_key/2)

      assert {:error, {:init, :config_in_wrong_format}} = Init.run(:example_name)
    end

    @tag :capture_log
    test "when reading modules fails, return error" do
      Mimic.expect(SideEffectsWrapper, :application_get_env, 1, fn :super_seed, :inserters ->
        %{
          example_name: %{
            namespace: ExampleNamespace,
            repo: ExampleNamespace.Repo,
            app: :example_app
          }
        }
      end)

      Mimic.expect(SideEffectsWrapper, :application_get_key, 1, fn :example_app, :modules ->
        :undefined
      end)

      assert {:error, {:init, :inserter_modules_not_found}} = Init.run(:example_name)
    end
  end
end
