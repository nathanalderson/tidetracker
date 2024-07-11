defmodule Tidetracker.Accounts.Token do
  use Ash.Resource,
    data_layer: AshSqlite.DataLayer,
    extensions: [AshAuthentication.TokenResource, AshAdmin.Resource],
    authorizers: [Ash.Policy.Authorizer],
    domain: Tidetracker.Accounts

  sqlite do
    table "tokens"
    repo Tidetracker.Repo
  end

  policies do
    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
      authorize_if always()
    end
  end
end
