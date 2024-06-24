defmodule Tidetracker.Meets.Resource do
  defmacro __using__(opts) do
    quote do
      use Ash.Resource,
        domain: Tidetracker.Meets,
        data_layer: AshSqlite.DataLayer

      sqlite do
        table unquote(opts[:table])
        repo Tidetracker.Repo
      end
    end
  end
end
