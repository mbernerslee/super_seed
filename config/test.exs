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
config :logger, level: :warning

config :super_seed,
  inserters: %{
    farms: %{namespace: SuperSeed.Support.Inserters, repo: SuperSeed.Repo, app: :super_seed}
  }
