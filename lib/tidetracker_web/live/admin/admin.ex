defmodule TidetrackerWeb.Admin.AdminLive do
  use TidetrackerWeb, :live_view
  alias TidetrackerWeb.Components.LargeTitleFrame
  require Logger

  def render(assigns) do
    ~H"""
    <LargeTitleFrame.default subtitle="Admin">
      <div class="mt-10 flex flex-col items-center justify-center gap-y-6">
        <.link_button url={~p"/admin/meets"} class="w-60">Manage Meets</.link_button>
      </div>
      <:footer>
        <.link href={~p"/"}>
          Home <.icon name="hero-chevron-right" class="h-4 w-4" />
        </.link>
      </:footer>
    </LargeTitleFrame.default>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(hide_nav: true)

    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
