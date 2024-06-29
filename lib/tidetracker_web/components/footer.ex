defmodule TidetrackerWeb.Components.Footer do
  use TidetrackerWeb, :component

  attr :href, :string, default: nil
  attr :navigate, :string, default: nil
  attr :patch, :string, default: nil
  attr :icon_name, :string, required: true
  slot :inner_block, required: true

  def footer_link(assigns) do
    ~H"""
    <.link
      href={@href}
      navigate={@navigate}
      patch={@patch}
      class="p-4 flex items-center gap-x-2 text-gray-400 hover:text-gray-300"
    >
      <.icon name={@icon_name} class="h-5 w-5" /><%= render_slot(@inner_block) %>
    </.link>
    """
  end

  def global_footer_links(assigns) do
    ~H"""
    <Components.Footer.footer_link href={~p"/"} icon_name="hero-home">Home</Components.Footer.footer_link>
    """
  end
end
