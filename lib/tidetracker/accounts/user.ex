defmodule Tidetracker.Accounts.User do
  use Ash.Resource,
    data_layer: AshSqlite.DataLayer,
    extensions: [AshAuthentication, AshAdmin.Resource],
    authorizers: [Ash.Policy.Authorizer],
    domain: Tidetracker.Accounts

  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false, public?: true
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  authentication do
    strategies do
      password :password do
        identity_field :email
      end
    end

    tokens do
      enabled? true
      token_resource Tidetracker.Accounts.Token
      signing_secret Tidetracker.Accounts.Secrets
    end
  end

  sqlite do
    table "users"
    repo Tidetracker.Repo
  end

  admin do
    actor? true
  end

  identities do
    identity :unique_email, [:email]
  end

  # You can customize this if you wish, but this is a safe default that
  # only allows user data to be interacted with via AshAuthentication.
  policies do
    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
      authorize_if always()
    end

    policy always() do
      forbid_if always()
    end
  end
end
