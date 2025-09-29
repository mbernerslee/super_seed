defmodule ClientTestApp.Repo do
  use Ecto.Repo,
    otp_app: :client_test_app,
    adapter: Ecto.Adapters.Postgres
end
