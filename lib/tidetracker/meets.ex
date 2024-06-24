defmodule Tidetracker.Meets do
  use Ash.Domain

  resources do
    resource Tidetracker.Meets.Team
    resource Tidetracker.Meets.Meet
    resource Tidetracker.Meets.MeetTeam
  end
end
