defmodule Tidetracker.Meets do
  use Ash.Domain

  resources do
    resource Tidetracker.Meets.Team
    resource Tidetracker.Meets.Meet
    resource Tidetracker.Meets.MeetTeam
  end

  def resource do
    quote do
      use Ash.Resource, domain: Tidetracker.Meets
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
