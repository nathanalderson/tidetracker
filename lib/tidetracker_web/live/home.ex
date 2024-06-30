defmodule TidetrackerWeb.HomeLive do
  use TidetrackerWeb, :live_view
  require Logger
  alias TidetrackerWeb.Components.LargeTitleFrame
  alias Tidetracker.Meets.Meet

  def render(assigns) do
    ~H"""
    <LargeTitleFrame.default>
      <div class="mx-auto mt-4 max-w-max text-sm">
        <Components.SelectMeet.select_meet meets={@meets} selected={@meet} />
      </div>
      <div class="mt-10 flex flex-col items-center justify-center gap-y-6">
        <.link_button :for={{page, url} <- @pages} url={url} class="w-60"><%= page %></.link_button>
      </div>
      <:footer_link>
        <Components.Footer.footer_link patch={~p"/admin"} icon_name="hero-cog-6-tooth">
          Admin
        </Components.Footer.footer_link>
      </:footer_link>
    </LargeTitleFrame.default>
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
          |> assign(pages: Components.Navbar.meet_pages())
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
