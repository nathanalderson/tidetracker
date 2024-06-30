defmodule TidetrackerWeb.Components.Footer do
  use TidetrackerWeb, :component

  slot :footer_link

  def footer(assigns) do
    ~H"""
    <footer class="text-gray-500">
      <div class="mx-auto max-w-7xl overflow-hidden px-6 py-20 sm:py-24 lg:px-8">
        <nav class="-mb-6 columns-2 sm:flex sm:justify-center sm:space-x-12" aria-label="Footer">
          <%= for link <- @footer_link do %>
            <%= render_slot(link) %>
          <% end %>
        </nav>
        <p class="mt-10 text-center text-xs leading-5 text-gray-500">
          &copy; <a href="https://nathanalderson.com" class="underline decoration-dotted">Nathan Alderson</a>. All rights reserved.
        </p>
      </div>
    </footer>
    """
  end

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
end
