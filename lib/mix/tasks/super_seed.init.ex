defmodule Mix.Tasks.SuperSeed.Init do
  use Mix.Task
  require Mix.Generator
  alias SuperSeed.ConfigReader

  def run(_args \\ []) do
    %{dir: dir, app: _app, repo: _repo, root_namespace: root_namespace} = ConfigReader.read()
    root_namespace = parse_root_namespace(root_namespace)

    root_dir = "lib/super_seed/#{dir}"
    Mix.Generator.create_directory(root_dir)
    Mix.Generator.create_directory("#{root_dir}/inserters")

    setup_file_path = "#{root_dir}/setup.ex"

    if File.exists?(setup_file_path) do
      log(:yellow, :already_exists, setup_file_path)
    else
      log(:green, :creating, setup_file_path)
      File.write!(setup_file_path, setup_file_contents(root_namespace))
    end

    :ok
  end

  defp parse_root_namespace(root_namespace) do
    root_namespace
    |> to_string()
    |> String.split("Elixir.")
    |> case do
      ["", module] ->
        module

      error ->
        raise """
        I expect :root_namespace to be a module name, but it isn't.
        I got #{error}, so I'm giving up!

        Check the config and make sure the :root_namespace value is a real module name.

        config :super_seed, :setup, [
          [repo: SuperSeed.ExampleRepo, app: :super_seed, root_namespace: SuperSeed, dir: "super_seed"]
        ]
        """
    end
  end

  defp log(colour, command, message) do
    Mix.shell().info([colour, "* #{command} ", :reset, message])
  end

  defp setup_file_contents(app_module) do
    """
    defmodule #{app_module}.SuperSeed.Setup do
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
  end
end
