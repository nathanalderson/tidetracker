defmodule TidetrackerWeb.Admin.MeetsLive do
  use TidetrackerWeb, :live_view
  require Logger
  alias Tidetracker.Meets.Meet

  def render(assigns) do
    ~H"""
    <div class="py-24 sm:py-32 lg:pb-40">
      <div class="mx-auto max-w-7xl px-6 lg:px-8">
        <div class="mx-auto max-w-2xl text-center">
          <h1 class="flex flex-col text-4xl font-bold font-display text-white sm:text-6xl">
            <span class={"text-transparent bg-clip-text #{orange_bg_gradient()}"}>Tidetracker</span>
            <span class="text-2xl">Meets</span>
          </h1>
          <.meets meets={@meets} />
        </div>
      </div>
      <div class="mt-40 text-gray-500 max-w-lg mx-auto flex flex-col items-center hover:text-gray-400 active:text-gray-600">
        <div>
          <.link href={~p"/"}>Home <.icon name="hero-chevron-right" class="h-4 w-4" /></.link>
        </div>
      </div>
    </div>
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
