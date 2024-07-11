defmodule TidetrackerWeb.Auth.Overrides do
  use AshAuthentication.Phoenix.Overrides
  alias AshAuthentication.Phoenix.Components
  import TidetrackerWeb.Utils

  override Components.Banner do
    set :image_url, nil
    set :dark_image_url, nil
    set :text, "Tidetracker"
    set :text_class, "text-4xl font-bold font-display text-transparent bg-clip-text #{orange_bg_gradient()} sm:text-6x"
  end

  override Components.Password.Input do
    set :input_class,
        [
          "block w-full rounded-md border-0 bg-white/5 py-1.5 text-white shadow-sm ring-1 ring-inset focus:ring-2 focus:ring-inset sm:text-sm sm:leading-6",
          "ring-white/10 focus:ring-brand"
        ]

    set :input_class_with_error, [
      "block w-full rounded-md border-0 bg-white/5 py-1.5 text-white shadow-sm ring-1 ring-inset focus:ring-2 focus:ring-inset sm:text-sm sm:leading-6",
      "ring-orange/60 focus:ring-orange"
    ]

    set :label_class, "block text-sm font-medium text-white mb-1"
  end
end
