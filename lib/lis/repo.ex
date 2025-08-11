defmodule LIS.Repo do
  use Ecto.Repo,
    otp_app: :lis,
    adapter: Ecto.Adapters.SQLite3
end
