defmodule Tidetracker.Meets.Meet do
  use Tidetracker.Meets.Resource, table: "meet"
  alias Tidetracker.Meets.MeetTeam
  alias Tidetracker.Meets.Team

  actions do
    defaults [:read]
    create :create
  end

  attributes do
    integer_primary_key :id

    attribute :date, :date do
      allow_nil? false
      public? true
    end
  end

  relationships do
    many_to_many :teams, Team do
      through MeetTeam
      source_attribute_on_join_resource :meet_id
      destination_attribute_on_join_resource :team_id
    end
  end
end
