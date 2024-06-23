defmodule Tidetracker.Meets.MeetTeam do
  use Tidetracker.Meets, :resource
  alias Tidetracker.Meets.Meet
  alias Tidetracker.Meets.Team

  relationships do
    belongs_to :meet, Meet, primary_key?: true, allow_nil?: false
    belongs_to :team, Team, primary_key?: true, allow_nil?: false
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end
end
