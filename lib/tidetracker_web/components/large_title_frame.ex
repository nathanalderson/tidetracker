defmodule TidetrackerWeb.Components.LargeTitleFrame do
  use TidetrackerWeb, :component

  attr :subtitle, :string
  slot :inner_block
  slot :footer

  def default(assigns) do
    ~H"""
    <div class="py-24 sm:py-32 lg:pb-40">
      <div class="mx-auto max-w-7xl px-6 lg:px-8">
        <div class="mx-auto max-w-2xl text-center">
          <h1 class="flex flex-col text-4xl font-bold font-display text-white sm:text-6xl">
            <span class={"text-transparent bg-clip-text #{orange_bg_gradient()}"}>Tidetracker</span>
            <span :if={assigns[:subtitle]} class="text-2xl"><%= @subtitle %></span>
          </h1>
          <%= render_slot(@inner_block) %>
        </div>
      </div>
      <div class="mt-40 text-gray-500 max-w-lg mx-auto flex flex-col items-center hover:text-gray-400 active:text-gray-600">
        <div>
          <%= render_slot(@footer) %>
        </div>
      </div>
    </div>
    """
  end
end
