defmodule Tidetracker.Repo do
  use Ecto.Repo,
    otp_app: :tidetracker,
    adapter: Ecto.Adapters.SQLite3
end
