defmodule SuperSeed.Repo do
  use Ecto.Repo,
    otp_app: :super_seed,
    adapter: Ecto.Adapters.Postgres
end
