defmodule TidetrackerWeb.HomeLive do
  use TidetrackerWeb, :live_view
  alias TidetrackerWeb.Router

  @meets %{
    1 => {1, "Meet 1", ~D"2024-06-01"},
    2 => {2, "Meet 2", ~D"2024-06-02"},
    3 => {3, "Meet 3", ~D"2024-06-03"}
  }

  def render(assigns) do
    ~H"""
    <div class="py-24 sm:py-32 lg:pb-40">
      <div class="mx-auto max-w-7xl px-6 lg:px-8">
        <div class="mx-auto max-w-2xl text-center">
          <h1 class="flex flex-col text-4xl font-bold font-display text-white sm:text-6xl">
            <span class={"text-transparent bg-clip-text #{orange_bg_gradient()}"}>Tidetracker</span>
          </h1>
          <div class="mx-auto mt-4 max-w-max text-sm">
            <Components.SelectMeet.select_meet meets={@meets} />
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

    socket =
      socket
      |> assign(pages: Router.meet_pages())
      |> assign(hide_nav: true)
      |> assign(meets: @meets)
      |> assign(meet: @meets[meet_id])

    {:ok, socket}
  end

  def mount(params, _session, socket) do
    dbg(params)
    latest_meet = @meets[3]
    {:ok, redirect(socket, to: ~p"/?meet-id=#{latest_meet[0]}")}
  end
end
