defmodule TidetrackerWeb.Router do
  use TidetrackerWeb, :router
  import AshAdmin.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TidetrackerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TidetrackerWeb do
    pipe_through :browser

    live_session :default do
      live "/", HomeLive
    end
  end

  scope "/admin", TidetrackerWeb.Admin, assigns: %{page_title: "Admin"} do
    pipe_through [:browser]

    live_session :admin, layout: {TidetrackerWeb.Layouts, :admin} do
      live "/", AdminLive
      live "/meets", MeetsLive
      live "/meet/:meet_id", MeetLive
    end
  end

  scope "/" do
    pipe_through :browser
    ash_admin "/ash-admin"
  end

  # Other scopes may use custom stacks.
  # scope "/api", TidetrackerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:tidetracker, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TidetrackerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
