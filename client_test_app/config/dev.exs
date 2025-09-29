import Config

config :client_test_app, ecto_repos: [ClientTestApp.Repo]

config :client_test_app, ClientTestApp.Repo,
  username: System.get_env("PGUSER") || "postgres",
  password: System.get_env("PGPASSWORD") || "postgres",
  hostname: System.get_env("PGHOST") || "localhost",
  port: String.to_integer(System.get_env("PGPORT") || "5432"),
  database: System.get_env("PGDATABASE_TEST") || "client_test_app_dev",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# Disable debug logging in tests
# config :logger, level: :debug
config :logger, level: :warning

config :super_seed,
  default_inserter_group: :farms,
  inserter_groups: %{
    farms: %{
      namespace: ClientTestApp.SuperSeed.Farming,
      repo: ClientTestApp.Repo,
      app: :client_test_app
    }
  }
