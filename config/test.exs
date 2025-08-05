import Config

config :super_seed, ecto_repos: [SuperSeed.Repo]

config :super_seed, SuperSeed.Repo,
  username: System.get_env("PGUSER") || "postgres",
  password: System.get_env("PGPASSWORD") || "postgres",
  hostname: System.get_env("PGHOST") || "localhost",
  port: String.to_integer(System.get_env("PGPORT") || "5432"),
  database: System.get_env("PGDATABASE_TEST") || "super_seed_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# Disable debug logging in tests
config :logger, level: :debug

config :super_seed,
  default_inserter_group: :farms,
  # TODO rename this to inserter_groups ?
  inserters: %{
    farms: %{
      namespace: SuperSeed.Support.Inserters.Farming,
      repo: SuperSeed.Repo,
      app: :super_seed
    },
    simple_example: %{
      namespace: SuperSeed.Support.Inserters.SimpleExample,
      repo: SuperSeed.Repo,
      app: :super_seed
    }
  }

config :super_seed, side_effects_wrapper_module: SuperSeed.SideEffectsWrapper.Fake
