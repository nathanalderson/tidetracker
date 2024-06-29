defmodule TidetrackerWeb.Admin.MeetsLive do
  use TidetrackerWeb, :live_view
  require Logger
  alias Tidetracker.Meets.Meet

  def render(assigns) do
    ~H"""
    <Components.LargeTitleFrame.default subtitle="Admin">
      <.meets meets={@meets} />
      <:footer_link>
        <Components.Footer.footer_link patch={~p"/admin"} icon_name="hero-cog-6-tooth">
          Admin home
        </Components.Footer.footer_link>
      </:footer_link>
      <:footer_link>
        <Components.Footer.footer_link patch={~p"/ash-admin"} icon_name="hero-cog">
          Ash Admin
        </Components.Footer.footer_link>
      </:footer_link>
    </Components.LargeTitleFrame.default>
    """
  end

  defp meets(assigns) do
    ~H"""
    <div class="text-left">
      <ul role="list" class="mt-10 divide-y divide-gray-700">
        <li :for={meet <- @meets} class="relative py-5 hover:bg-gray-800">
          <div class="px-4 sm:px-6 lg:px-8">
            <div class="mx-auto flex max-w-4xl justify-between gap-x-6">
              <div class="flex min-w-0 gap-x-4">
                <div class="min-w-0 flex-auto">
                  <p class="text-sm font-semibold leading-6 text-white">
                    <.link patch={~p"/admin/meet/#{meet.id}"}>
                      <span class="absolute inset-x-0 -top-px bottom-0"></span>
                      <%= meet.description %>
                    </.link>
                  </p>
                  <p class="mt-1 flex text-xs leading-5 text-gray-400">
                    <time datetime={meet.date}><%= meet.date %></time>
                  </p>
                </div>
              </div>
              <div class="flex shrink-0 items-center gap-x-4">
                <.icon name="hero-chevron-right" class="h-5 w-5 flex-none text-gray-400" />
              </div>
            </div>
          </div>
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
