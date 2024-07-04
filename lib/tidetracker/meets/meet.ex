defmodule Tidetracker.Meets.Meet do
  use Tidetracker.Meets.Resource, table: "meet"
  alias Tidetracker.Meets.Calculations.MeetDescription
  alias Tidetracker.Meets.MeetTeam
  alias Tidetracker.Meets.Pool
  alias Tidetracker.Meets.Team

  attributes do
    integer_primary_key :id

    attribute :name, :string do
      allow_nil? true
      public? true
    end

    attribute :date, :date do
      allow_nil? false
      public? true
    end
  end

  relationships do
    belongs_to :location, Pool

    many_to_many :teams, Team do
      through MeetTeam
      source_attribute_on_join_resource :meet_id
      destination_attribute_on_join_resource :team_id
    end
  end

  preparations do
    prepare build(sort: [date: :desc], load: [:description, :location, :teams])
  end

  calculations do
    calculate :description, :string, {MeetDescription, []}
  end

  code_interface do
    define :list, action: :read
    define :update, action: :update
    define :add_team, action: :add_team, args: [:team_id]
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      accept :*
      argument :location, :map
      change manage_relationship(:location, :location, type: :append_and_remove)
    end

    update :update do
      accept :*
      argument :location, :map, allow_nil?: true
      argument :teams, {:array, :map}, allow_nil?: true
      change manage_relationship(:location, :location, type: :append_and_remove)
      change manage_relationship(:teams, :teams, type: :append_and_remove)
    end

    update :add_team do
      argument :team_id, :integer, allow_nil?: false
      change manage_relationship(:team_id, :teams, type: :append)
    end
  end
end
