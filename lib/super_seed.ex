defmodule SuperSeed do
  require Logger
  alias SuperSeed.{Init, InserterModulesValidator, Server, SideEffectsWrapper}

  def run do
    Init.run() |> validate_and_run()
  end

  def run(name) do
    name |> Init.run() |> validate_and_run()
  end

  # TODO test that we call SideEffectsWrapper.application_ensure_all_started/1
  # and deal with it not working...
  defp validate_and_run(init_result) do
    with {:ok, %{repo: repo, inserters: inserters, app: app}} <- init_result,
         {:ok, _} <- SideEffectsWrapper.application_ensure_all_started(app),
         :ok <- InserterModulesValidator.validate(inserters) do
      Server.run(repo, inserters)

      receive do
        :server_done ->
          :ok

        :server_error ->
          Logger.error("""
            An inserter errored, so insertion was halted part way through, leaving the DB in an unknwon partially inserted state.
            I suggest you fix the error, reset the DB and try again
          """)

          {:error, :inserter}
      end
    else
      {:error, {:init, :inserter_modules_not_found}} ->
        Logger.error("""
        I could not find any modules for the `app` you specified in config under `:super_seed :inserters <your inserter group name>`

        - a typo?
        - your app did not compile so there are no modules?
        """)

        {:error, {:init, :inserter_modules_not_found}}

      {:error, {:init, :config_in_wrong_format}} ->
        Logger.error("""
        I could not parse your :super_seed config because it's in the wrong format

        - check config.exs for typos?
        - config should be like:

        config :super_seed,
          default_inserter_group: :my_group,
          inserter_groups: %{
            my_group: %{
              namespace: MyApp.SuperSeed.Inserters,
              repo: MyApp.Repo,
              app: :my_app
            }
          }
        """)

        {:error, {:init, :config_in_wrong_format}}

      {:error, {:init, :missing_config}} ->
        Logger.error("""
        I failed to find any :super_seed configuration because none exists

        - add this to your config/config.exs:

        config :super_seed,
          default_inserter_group: :my_group,
          inserter_groups: %{
            my_group: %{
              namespace: MyApp.SuperSeed.Inserters,
              repo: MyApp.Repo,
              app: :my_app
            }
          }
        """)

        {:error, {:init, :missing_config}}

      {:error, {:init, :inserter_group_not_found}} ->
        Logger.error("""
        I failed to find the inserter_group you specified because it doesn't exist in your config

        - use an existing group from your config?
        - or add a new group to your config:

        config :super_seed,
          inserter_groups: %{
            your_group_name: %{
              namespace: MyApp.SuperSeed.Inserters,
              repo: MyApp.Repo,
              app: :my_app
            }
          }
        """)

        {:error, {:init, :inserter_group_not_found}}

      {:error, {:init, :default_inserter_group_not_found}} ->
        Logger.error("""
        You did not specify an inserter group name, so I attempted to use the default inserter group name, but I failed to find a default inserter group because none is configured

          So either:

        - specify a group name: mix super_seed my_inserter_group_name
        - or add a default to your config:

        config :super_seed,
          default_inserter_group: :farms,
          inserter_groups: %{
            farms: %{
              namespace: MyApp.SuperSeed.Inserters.Farming,
              repo: MyApp.Repo,
              app: :my_app
            }
          }
        """)

        {:error, {:init, :default_inserter_group_not_found}}

      {:error, {:inserter_module_validation, module, :malformed}} ->
        Logger.error("""
        I failed to validate inserter module #{inspect(module)} because it's malformed

        - inserter modules must implement these functions:

        defmodule #{inspect(module)} do
          def table(), do: "my_table"

          def depends_on(), do: []

          def insert(_results) do
            # Your insertion logic here
          end
        end
        """)

        {:error, {:inserter_module_validation, module, :malformed}}
    end
  end
end
