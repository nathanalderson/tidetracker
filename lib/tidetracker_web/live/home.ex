defmodule TidetrackerWeb.HomeLive do
  use TidetrackerWeb, :live_view
  require Logger
  alias TidetrackerWeb.Router
  alias Tidetracker.Meets.Meet

  def render(assigns) do
    ~H"""
    <div class="py-24 sm:py-32 lg:pb-40">
      <div class="mx-auto max-w-7xl px-6 lg:px-8">
        <div class="mx-auto max-w-2xl text-center">
          <h1 class="flex flex-col text-4xl font-bold font-display text-white sm:text-6xl">
            <span class={"text-transparent bg-clip-text #{orange_bg_gradient()}"}>Tidetracker</span>
          </h1>
          <div class="mx-auto mt-4 max-w-max text-sm">
            <Components.SelectMeet.select_meet meets={@meets} selected={@meet} />
          </div>
          <div class="mt-10 flex flex-col items-center justify-center gap-y-6">
            <.link_button :for={{page, url} <- @pages} url={url} class="w-60"><%= page %></.link_button>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params = %{"meet-id" => meet_id}, _session, socket) do
    meet_id = meet_id |> String.to_integer()
    query = [load: [:location, :teams, :description]]
    meets = Meet.list!(query: query)

    socket =
      case Ash.get(Meet, meet_id, query) do
        {:ok, meet} ->
          socket
          |> assign(pages: Router.meet_pages())
          |> assign(hide_nav: true)
          |> assign(meets: meets)
          |> assign(meet: meet)

        {:error, reason} ->
          Logger.warning("Failed to load meet: #{inspect(reason)}")
          redirect(socket, to: ~p"/")
      end

    {:ok, socket}
  end

  def mount(_params, _session, socket) do
    meet = Ash.read_first!(Meet)
    {:ok, redirect(socket, to: ~p"/?meet-id=#{meet.id}")}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("select_meet", %{"select-meet" => meet_id}, socket) do
    {:noreply, push_patch(socket, to: ~p"/?meet-id=#{meet_id}")}
  end
end
