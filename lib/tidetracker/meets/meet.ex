defmodule Tidetracker.Meets.Meet do
  use Tidetracker.Meets, :resource
  alias Tidetracker.Meets.MeetTeam
  alias Tidetracker.Meets.Team

  actions do
    defaults [:read]
    create :create
  end

  attributes do
    integer_primary_key :id
    attribute :date, :date
  end

  relationships do
    many_to_many :teams, Team do
      through MeetTeam
      source_attribute_on_join_resource :meet_id
      destination_attribute_on_join_resource :team_id
    end
  end
end
