defmodule Mix.Tasks.SuperSeed.InitTest do
  use ExUnit.Case, async: true
  use Mimic
  import ExUnit.CaptureIO

  alias Mix.Tasks.SuperSeed.Init
  alias SuperSeed.Checks

  describe "run/1" do
    @tag :capture_io
    test "creates the file structure" do
      Mimic.expect(File, :exists?, fn path ->
        assert path == "lib/super_seed/my_test/setup.ex"
        false
      end)

      Mimic.expect(Checks, :application_get_env, fn _app, _key ->
        [
          [
            repo: MyTest.Repo,
            app: :my_test,
            root_namespace: MyTest,
            name: "my_test"
          ]
        ]
      end)

      Mimic.expect(File, :mkdir_p!, fn path -> assert path == "lib/super_seed/my_test" end)

      Mimic.expect(File, :mkdir_p!, fn path ->
        assert path == "lib/super_seed/my_test/inserters"
      end)

      Mimic.expect(File, :write!, fn path, contents ->
        assert path == "lib/super_seed/my_test/setup.ex"

        assert contents ==
                 """
                 defmodule MyTest.SuperSeed.Setup do
                   @behaviour SuperSeed.Setup

                   @impl true
                   def setup do
                     # Run any pre-seeding code here
                     # For example: truncating some tables, pausing a process that's very database sensitive
                     # The return value of this function will be passed to the teardown/1 function which is run after the seed data insertion is done
                     :ok
                   end

                   @impl true
                   def teardown(_setup) do
                     # Run any post-seeding code here
                     # For example: unpausing a process that's very database sensitive
                     # The argument to this function is the return value of the setup/0 function
                     :ok
                   end
                 end
                 """
      end)

      capture_io(fn -> assert :ok == Init.run() end)
    end

    test "if the setup file already exists, and has stuff in it, don't attempt to recreate it" do
      Mimic.expect(File, :exists?, fn path ->
        assert path == "lib/super_seed/my_test/setup.ex"
        true
      end)

      Mimic.expect(Checks, :application_get_env, fn _app, _key ->
        [
          [
            repo: MyTest.Repo,
            app: :my_test,
            root_namespace: MyTest,
            name: "my_test"
          ]
        ]
      end)

      Mimic.reject(File, :write!, 2)
      capture_io(fn -> Init.run() end)
    end

    test "if root_namespace isn't a proper module name, then raise" do
      Mimic.expect(Checks, :application_get_env, fn _app, _key ->
        [
          [
            repo: MyTest.Repo,
            app: :my_test,
            root_namespace: :nonsense,
            name: "my_test"
          ]
        ]
      end)

      Mimic.reject(File, :write!, 2)

      msg = ~r|I expect :root_namespace to be a module name, but it isn't|

      assert_raise RuntimeError, msg, fn -> Init.run() end
    end

    test "when there's more than one named configuration and a name is specified, we init the correct one" do
      Mimic.expect(File, :exists?, fn path ->
        assert path == "lib/super_seed/pears/setup.ex"
        false
      end)

      Mimic.expect(Checks, :application_get_env, fn _app, _key ->
        [
          [
            repo: MyTest.Repo,
            app: :my_test,
            root_namespace: MyTest,
            name: "my_test"
          ],
          [
            repo: Pears.Repo,
            app: :pears,
            root_namespace: Pears,
            name: "pears"
          ]
        ]
      end)

      Mimic.expect(File, :mkdir_p!, fn path -> assert path == "lib/super_seed/pears" end)

      Mimic.expect(File, :mkdir_p!, fn path ->
        assert path == "lib/super_seed/pears/inserters"
      end)

      Mimic.expect(File, :write!, fn path, contents ->
        assert path == "lib/super_seed/pears/setup.ex"

        assert contents ==
                 """
                 defmodule Pears.SuperSeed.Setup do
                   @behaviour SuperSeed.Setup

                   @impl true
                   def setup do
                     # Run any pre-seeding code here
                     # For example: truncating some tables, pausing a process that's very database sensitive
                     # The return value of this function will be passed to the teardown/1 function which is run after the seed data insertion is done
                     :ok
                   end

                   @impl true
                   def teardown(_setup) do
                     # Run any post-seeding code here
                     # For example: unpausing a process that's very database sensitive
                     # The argument to this function is the return value of the setup/0 function
                     :ok
                   end
                 end
                 """
      end)

      capture_io(fn -> assert :ok == Init.run(["--name", "pears"]) end)
    end
  end
end
