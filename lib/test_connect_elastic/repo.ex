defmodule TestConnectElastic.Repo do
  use Ecto.Repo,
    otp_app: :test_connect_elastic,
    adapter: Ecto.Adapters.Postgres
end
