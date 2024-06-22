defmodule TidetrackerWeb.Components.Buttons do
  use TidetrackerWeb, :component

  attr :url, :string
  attr :label, :string

  def link_button(assigns) do
    ~H"""
    <a
      href={@url}
      class="w-40 rounded-md bg-gradient-to-r from-violet-900 to-violet-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-violet-400 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-violet-400"
    >
      <%= @label %>
    </a>
    """
  end
end
