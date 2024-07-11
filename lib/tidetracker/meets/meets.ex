defmodule Tidetracker.Meets do
  use Ash.Domain,
    extensions: [AshAdmin.Domain]

  resources do
    resource Tidetracker.Meets.Meet
    resource Tidetracker.Meets.MeetTeam
    resource Tidetracker.Meets.Pool
    resource Tidetracker.Meets.Team
  end

  admin do
    show? true
  end
end
