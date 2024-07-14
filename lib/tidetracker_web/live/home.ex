defmodule TidetrackerWeb.HomeLive do
  use TidetrackerWeb, :live_view
  require Logger
  alias Tidetracker.Meets.Meet

  @meet_preload [:location, :teams, :description]

  def render(assigns) do
    ~H"""
    <div class="py-24 sm:py-32 lg:pb-40">
      <div class="mx-auto max-w-7xl px-6 lg:px-8">
        <div class="mx-auto max-w-2xl text-center">
          <h1 class="flex flex-col text-4xl font-bold font-display text-white sm:text-6xl">
            <span class={"text-transparent bg-clip-text #{orange_bg_gradient()}"}>Tidetracker</span>
            <span :if={assigns[:subtitle]} class="text-brand text-2xl"><%= @subtitle %></span>
          </h1>
          <div class="mx-auto mt-4 max-w-max text-sm">
            <Components.SelectMeet.select_meet meets={@meets} selected={@meet} />
          </div>
          <div class="mt-10 flex flex-col items-center justify-center gap-y-6">
            <.link_button :for={{page, url} <- @pages} url={url} class="w-60"><%= page %></.link_button>
          </div>
        </div>
      </div>
      <Components.Footer.footer>
        <:footer_link>
          <Components.Footer.footer_link patch={~p"/admin"} icon_name="hero-cog-6-tooth">
            Admin
          </Components.Footer.footer_link>
        </:footer_link>
      </Components.Footer.footer>
    </div>
    """
  end

  def mount(_params = %{"meet-id" => meet_id}, _session, socket) do
    socket =
      case Ash.get(Meet, meet_id, load: @meet_preload) do
        {:ok, meet} ->
          socket
          |> assign_defaults()
          |> assign(meet: meet)

        {:error, _} ->
          redirect(socket, to: ~p"/")
      end

    {:ok, socket}
  end

  def mount(_params, _session, socket) do
    socket = assign_defaults(socket)
    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp assign_defaults(socket) do
    socket
    |> assign(pages: Components.Navbar.meet_pages())
    |> assign(hide_nav: true)
    |> assign(meets: Meet.list!(query: [load: @meet_preload]))
    |> assign(meet: nil)
  end

  def handle_event("select_meet", %{"select-meet" => meet_id}, socket) do
    {:noreply, push_patch(socket, to: ~p"/?meet-id=#{meet_id}")}
  end
end
