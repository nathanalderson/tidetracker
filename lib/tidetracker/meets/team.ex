defmodule Tidetracker.Meets.Team do
  use Tidetracker.Meets.Resource, table: "team"
  alias Tidetracker.Meets.MeetTeam
  alias Tidetracker.Meets.Meet
  alias Tidetracker.Meets.Pool

  attributes do
    integer_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end
  end

  relationships do
    belongs_to :home_pool, Pool

    many_to_many :meets, Meet do
      through MeetTeam
      source_attribute_on_join_resource :team_id
      destination_attribute_on_join_resource :meet_id
    end
  end

  admin do
    relationship_display_fields([:name])
  end

  preparations do
    prepare build(load: [:home_pool, :description])
  end

  calculations do
    calculate :description, :string, expr("#{home_pool.name} #{name}")
  end

  actions do
    defaults [:read, :destroy, update: :*]

    create :create do
      accept :*
      argument :home_pool, :map
      change manage_relationship(:home_pool, :home_pool, type: :append_and_remove)
    end
  end
end
