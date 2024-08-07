defmodule TidetrackerWeb.Components.Navbar do
  use TidetrackerWeb, :component

  def meet_pages(),
    do: [
      Home: ~p"/",
      Heatsheet: "#",
      Results: "#",
      Scoreboard: "#"
    ]

  def admin_pages(),
    do: [
      Home: ~p"/",
      "Admin home": ~p"/admin",
      "Ash dashboard": ~p"/ash-admin"
    ]

  attr :pages, :list, default: []
  attr :hide_nav, :boolean, default: false
  attr :back_link, :any
  attr :current_user, :any, default: nil

  def navbar(assigns) do
    ~H"""
    <header x-data="{open: false}" class="absolute inset-x-0 top-0 z-50">
      <nav :if={!@hide_nav} class="flex items-center justify-between p-6 lg:px-8" aria-label="Global">
        <div class="flex lg:flex-1">
          <.logo />
        </div>
        <div class="flex lg:hidden">
          <button
            x-on:click="open = !open"
            type="button"
            class="-m-2.5 inline-flex items-center justify-center rounded-md p-2.5 text-gray-400"
          >
            <span class="sr-only">Open main menu</span>
            <.icon name="hero-bars-3" class="h-6 w-6" />
          </button>
        </div>
        <div class="hidden lg:flex lg:gap-x-12">
          <a :for={{page, url} <- @pages} href={url} class="text-sm font-semibold leading-6 text-gray-400 hover:text-brand">
            <%= page %>
          </a>
        </div>
        <div class="hidden lg:flex lg:flex-1 lg:justify-end">
          <.account_info current_user={@current_user} />
        </div>
      </nav>
      <!-- Mobile menu -->
      <div x-cloak x-show="open" class="lg:hidden" role="dialog" aria-modal="true">
        <!-- Background backdrop -->
        <div x-cloak x-show="open" class="fixed inset-0 z-50"></div>
        <div class="fixed inset-y-0 right-0 z-50 w-full overflow-y-auto bg-gray-900 px-6 py-6 sm:max-w-sm sm:ring-1 sm:ring-white/10">
          <div class="flex items-center justify-between">
            <.logo />
            <button x-on:click="open = false" type="button" class="-m-2.5 rounded-md p-2.5 text-gray-400">
              <span class="sr-only">Close menu</span>
              <.icon name="hero-x-mark" class="h-6 w-6" />
            </button>
          </div>
          <div class="mt-6 flow-root">
            <div class="-my-6 divide-y divide-gray-500/25">
              <div class="space-y-2 py-6">
                <a
                  :for={{page, url} <- @pages}
                  href={url}
                  class="-mx-3 block rounded-lg px-3 py-2 text-base font-semibold leading-7 text-white hover:bg-gray-800"
                >
                  <%= page %>
                </a>
              </div>
              <div class="py-6"></div>
            </div>
          </div>
        </div>
      </div>

      <.link
        :if={@back_link}
        {@back_link}
        class="absolute text-gray-400 flex items-center top-14 left-1 lg:top-20 lg:left-3"
      >
        <.icon name="hero-chevron-left" class="h-4 w-4" /> Back
      </.link>
    </header>
    """
  end

  defp logo(assigns) do
    ~H"""
    <a href={~p"/"} class="-m-1.5 p-1.5">
      <span class="sr-only">Tidetracker</span>
      <span class={"font-display font-bold text-transparent bg-clip-text #{orange_bg_gradient()}"}>
        Tidetracker
      </span>
    </a>
    """
  end

  defp account_info(assigns) do
    ~H"""
    <div :if={@current_user} class="flex items-center gap-2">
      <span class="text-sm font-medium text-brand rounded-md">
        <%= @current_user.email %>
      </span>
      <a
        href={~p"/logout"}
        class="flex items-center text-sm font-semibold leading-6 text-brand hover:text-brand-lighter active:text-brand/70"
      >
        <.icon name="hero-arrow-right-start-on-rectangle-micro" class="h-5 w-5" />
      </a>
    </div>
    """
  end
end
