env_uses_db? = Application.compile_env(:super_seed, SuperSeed.Repo) != nil

if env_uses_db? do
  defmodule SuperSeed.Repo do
    use Ecto.Repo,
      otp_app: :super_seed,
      adapter: Ecto.Adapters.Postgres
  end
end
