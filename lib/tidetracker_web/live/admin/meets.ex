defmodule TidetrackerWeb.Admin.MeetsLive do
  use TidetrackerWeb, :live_view
  require Logger
  alias Tidetracker.Meets.Meet

  def render(assigns) do
    ~H"""
    <div class="my-8 sm:my-20">
      <.meets_new meets={@meets} />
    </div>
    """
  end

  defp meets_new(assigns) do
    ~H"""
    <div class="w-full px-2">
      <.button type="button" class="w-full" phx-click="create_meet">
        Create Meet
      </.button>
    </div>

    <ul
      role="list"
      class="mx-auto divide-y divide-gray-700 overflow-hidden bg-gray-900/50 shadow-sm ring-1 ring-gray-900/5 max-w-7xl sm:rounded-xl"
    >
      <li :for={meet <- @meets} class="relative flex justify-between gap-x-6 px-4 py-5 hover:bg-gray-900/60 sm:px-6">
        <div class="flex min-w-0 gap-x-4">
          <div class="min-w-0 flex-auto">
            <p class="text-sm font-semibold leading-6 text-white">
              <a href={~p"/admin/meet/#{meet.id}"}>
                <span class="absolute inset-x-0 -top-px bottom-0"></span>
                <%= meet.description %>
              </a>
            </p>
            <p class="mt-1 flex text-xs leading-5 text-gray-400">
              <.link navigate="mailto:leslie.alexander@example.com" class="relative truncate hover:underline">
                <time datetime={meet.date}><%= meet.date %></time>
              </.link>
            </p>
          </div>
        </div>
        <div class="flex shrink-0 items-center gap-x-4">
          <.icon name="hero-chevron-right" class="h-5 w-5 flex-none text-gray-400" />
        </div>
      </li>
    </ul>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(meets: Meet.list!())

    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("create_meet", _params, socket) do
    new_meet =
      Meet
      |> Ash.Changeset.for_create(:create, %{date: Timex.today()})
      |> Ash.create!()

    socket =
      socket
      |> update(:meets, fn meets -> [new_meet | meets] end)
      |> put_flash(:info, :created)
      |> push_navigate(to: ~p"/admin/meet/#{new_meet.id}")

    {:noreply, socket}
  end
end
