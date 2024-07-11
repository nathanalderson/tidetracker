defmodule Tidetracker.Accounts do
  use Ash.Domain, extensions: [AshAdmin.Domain]

  resources do
    resource Tidetracker.Accounts.User
    resource Tidetracker.Accounts.Token
  end

  admin do
    show? true
  end
end
