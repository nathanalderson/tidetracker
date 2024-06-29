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
