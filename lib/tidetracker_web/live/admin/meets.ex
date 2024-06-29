defmodule TidetrackerWeb.Admin.MeetsLive do
  use TidetrackerWeb, :live_view
  alias TidetrackerWeb.Components.LargeTitleFrame
  require Logger
  alias Tidetracker.Meets.Meet

  def render(assigns) do
    ~H"""
    <LargeTitleFrame.default subtitle="Admin">
      <.meets meets={@meets} />
      <:footer>
        <.link href={~p"/"}>
          Home <.icon name="hero-chevron-right" class="h-4 w-4" />
        </.link>
      </:footer>
    </LargeTitleFrame.default>
    """
  end

  defp meets(assigns) do
    ~H"""
    <div>
      <ul class="mt-10 flex flex-col gap-y-6">
        <li :for={meet <- @meets}>
          <.link patch={~p"/admin/meets/#{meet.id}"} class="text-brand w-60"><%= meet.description %></.link>
        </li>
      </ul>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(hide_nav: true)
      |> assign(meets: Meet.list!(load: [:description]))

    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
