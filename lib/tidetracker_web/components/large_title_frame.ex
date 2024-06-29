defmodule TidetrackerWeb.Components.LargeTitleFrame do
  use TidetrackerWeb, :component

  attr :subtitle, :string
  attr :back_link, :any, default: []
  slot :inner_block
  slot :footer_link

  def default(assigns) do
    ~H"""
    <div class="py-24 sm:py-32 lg:pb-40">
      <div class="mx-auto max-w-7xl px-6 lg:px-8">
        <div class="mx-auto max-w-2xl text-center">
          <h1 class="flex flex-col text-4xl font-bold font-display text-white sm:text-6xl">
            <span class={"text-transparent bg-clip-text #{orange_bg_gradient()}"}>Tidetracker</span>
            <span :if={assigns[:subtitle]} class="text-brand text-2xl"><%= @subtitle %></span>
          </h1>
          <.link :if={!Enum.empty?(@back_link)} {@back_link}>Back</.link>
          <%= render_slot(@inner_block) %>
          <.link :if={!Enum.empty?(@back_link)} {@back_link}>Back</.link>
        </div>
      </div>
      <footer class="text-gray-500">
        <div class="mx-auto max-w-7xl overflow-hidden px-6 py-20 sm:py-24 lg:px-8">
          <nav class="-mb-6 columns-2 sm:flex sm:justify-center sm:space-x-12" aria-label="Footer">
            <Components.Footer.global_footer_links />
            <%= for link <- @footer_link do %>
              <%= render_slot(link) %>
            <% end %>
          </nav>
          <p class="mt-10 text-center text-xs leading-5 text-gray-500">
            &copy; <a href="https://nathanalderson.com" class="underline decoration-dotted">Nathan Alderson</a>. All rights reserved.
          </p>
        </div>
      </footer>
    </div>
    """
  end
end
