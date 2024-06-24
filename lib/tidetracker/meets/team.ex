defmodule Tidetracker.Meets.Team do
  use Tidetracker.Meets.Resource, table: "team"
  alias Tidetracker.Meets.MeetTeam
  alias Tidetracker.Meets.Meet

  actions do
    defaults [:read, :create]
  end

  attributes do
    integer_primary_key :id

    attribute :pool_name, :string do
      allow_nil? false
      public? true
    end

    attribute :pool_short_name, :string do
      allow_nil? false
      public? true
    end

    attribute :team_name, :string do
      allow_nil? false
      public? true
    end
  end

  relationships do
    many_to_many :meets, Meet do
      through MeetTeam
      source_attribute_on_join_resource :team_id
      destination_attribute_on_join_resource :meet_id
    end
  end

  actions do
    default_accept [:team_name, :pool_short_name, :pool_name]
  end
end
