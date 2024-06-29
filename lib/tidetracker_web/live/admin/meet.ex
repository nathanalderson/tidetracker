defmodule TidetrackerWeb.Admin.MeetLive do
  use TidetrackerWeb, :live_view
  require Logger
  alias Tidetracker.Meets.Meet

  def render(assigns) do
    ~H"""
    <%= @meet.description %>
    """
  end

  def mount(params, _session, socket) do
    socket =
      socket
      |> assign(hide_nav: true)
      |> assign(meet: Ash.get!(Meet, params["meet_id"], load: [:description]))

    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
