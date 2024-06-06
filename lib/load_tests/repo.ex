defmodule LoadTests.Repo do
  use Ecto.Repo,
    otp_app: :load_tests,
    adapter: Ecto.Adapters.Postgres
end
