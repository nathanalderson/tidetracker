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
          <.link :if={!Enum.empty?(@back_link)} {@back_link} class="text-gray-400 flex items-center mt-8">
            <.icon name="hero-chevron-left" class="h-4 w-4" /> Back
          </.link>
          <%= render_slot(@inner_block) %>
        </div>
      </div>
      <Components.Footer.footer footer_link={@footer_link} />
    </div>
    """
  end
end
