defmodule SuperSeed.ConfigReaderTest do
  use ExUnit.Case, async: true
  use Mimic
  alias SuperSeed.{Checks, ConfigReader}
  alias SuperSeed.Mocks.FakeRepo

  describe "read/1" do
    test "it reads the config" do
      Mimic.expect(Checks, :application_get_env, fn app, key ->
        assert app == :super_seed
        assert key == :setup
        [[repo: FakeRepo, app: :fake_app, root_namespace: CoolApp, name: "my_app"]]
      end)

      assert %{repo: FakeRepo, app: :fake_app, root_namespace: CoolApp, name: "my_app"} ==
               ConfigReader.read()
    end

    test "when there's no config it raises with a helpful error" do
      Mimic.expect(Checks, :application_get_env, fn _app, _key ->
        nil
      end)

      error_msg = """
      I tried to read the :setup configuration for :super_seed, but it I didn't find any.
      Maybe you skipped the step in the README about adding some config to config/config.exs?
      """

      assert_raise RuntimeError, error_msg, &ConfigReader.read/0
    end

    test "if a key is missing from the config, raise with a helpful error" do
      Mimic.expect(Checks, :application_get_env, fn _app, _key ->
        [[repo: FakeRepo, name: "my_app", root_namespace: CoolApp]]
      end)

      error_msg = """
      I tried to read the :setup configuration for :super_seed, but it looks like I've been misconfigured.

      I'm missing the key: :app

      Maybe reread the README bit about adding some config?
      """

      assert_raise RuntimeError, error_msg, &ConfigReader.read/0

      Mimic.expect(Checks, :application_get_env, fn _app, _key ->
        [[repo: :cool_repo, app: :fake_app, root_namespace: CoolApp]]
      end)

      error_msg = """
      I tried to read the :setup configuration for :super_seed, but it looks like I've been misconfigured.

      I'm missing the key: :name

      Maybe reread the README bit about adding some config?
      """

      assert_raise RuntimeError, error_msg, &ConfigReader.read/0
    end

    test "if there's more than named setup, and no name is supplied, raise an error" do
      Mimic.expect(Checks, :application_get_env, fn app, key ->
        assert app == :super_seed
        assert key == :setup

        [
          [repo: FakeRepo, app: :fake_app, root_namespace: CoolApp, name: "my_app"],
          [repo: PearsRepo, app: :fake_app, root_namespace: Pears, name: "pears"]
        ]
      end)

      msg = """
      You have more than one named setup configured, so you must tell me which one you're using.
      Please specify with the argument

      --name name
      """

      assert_raise RuntimeError, msg, fn -> ConfigReader.read() end
    end

    test "if there's more than named setup, and a name is supplied, return the setup for that name" do
      Mimic.expect(Checks, :application_get_env, fn _app, _key ->
        [
          [repo: FakeRepo, app: :fake_app, root_namespace: CoolApp, name: "my_app"],
          [repo: Pears.Repo, app: :pears, root_namespace: Pears, name: "pears"]
        ]
      end)

      assert %{repo: Pears.Repo, app: :pears, root_namespace: Pears, name: "pears"} ==
               ConfigReader.read(["--name", "pears"])
    end

    test "if there's more than named setup, and a name is supplied but that name doesn't exist, raise an error" do
      Mimic.expect(Checks, :application_get_env, fn _app, _key ->
        [
          [repo: FakeRepo, app: :fake_app, root_namespace: CoolApp, name: "my_app"],
          [repo: Pears.Repo, app: :pears, root_namespace: Pears, name: "pears"]
        ]
      end)

      msg = """
      You told me to find a --name in config called "fail", but I couldn't find that in your config
      """

      assert_raise RuntimeError, msg, fn -> ConfigReader.read(["--name", "fail"]) end
    end

    test "given nonsense arguments, raises" do
      msg = """
      You provided some args I don't understand.
      Args I do understand:

      --name name
      """

      assert_raise RuntimeError, msg, fn -> ConfigReader.read(["--nonsense", "arg"]) end
    end
  end
end
