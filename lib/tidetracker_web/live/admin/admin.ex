defmodule TidetrackerWeb.Admin.AdminLive do
  use TidetrackerWeb, :live_view
  alias TidetrackerWeb.Components.LargeTitleFrame
  require Logger

  def render(assigns) do
    ~H""
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(hide_nav: true)
      |> push_navigate(to: ~p"/admin/meets")

    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
