defmodule Tidetracker.Meets.Pool do
  use Tidetracker.Meets.Resource, table: "pool"
  alias Tidetracker.Meets.Team

  attributes do
    integer_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    attribute :short_name, :string do
      allow_nil? false
      public? true
    end
  end

  admin do
    relationship_display_fields([:name])
  end

  relationships do
    has_many :teams, Team do
      destination_attribute :home_pool_id
    end
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end
end
