defmodule Tidetracker.Meets.Team do
  use Tidetracker.Meets, :resource
  alias Tidetracker.Meets.MeetTeam
  alias Tidetracker.Meets.Meet

  actions do
    defaults [:read]
    create :create
  end

  attributes do
    integer_primary_key :id
    attribute :pool_name, :string
    attribute :pool_short_name, :string
    attribute :team_name, :string
  end

  relationships do
    many_to_many :meets, Meet do
      through MeetTeam
      source_attribute_on_join_resource :team_id
      destination_attribute_on_join_resource :meet_id
    end
  end
end
