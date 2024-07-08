defmodule Tidetracker.Meets.Calculations.MeetDescription do
  use Ash.Resource.Calculation

  @impl true
  def load(_query, _opts, _context) do
    [location: :name, teams: :home_pool]
  end

  @impl true
  def calculate(records, _opts, _map) do
    Enum.map(records, fn meet ->
      if meet.name do
        meet.name
      else
        description(meet.location, meet.teams)
      end
    end)
  end

  defp description(location, [team1, team2]) do
    cond do
      location.id == team1.home_pool_id ->
        "@#{team1.description} vs #{team2.description}"

      location.id == team2.home_pool_id ->
        "@#{team2.description} vs #{team1.description}"

      true ->
        description(location, [])
    end
  end

  defp description(location, _) when not is_nil(location), do: "@#{location.name}"
  defp description(_, _), do: "New Meet"
end
