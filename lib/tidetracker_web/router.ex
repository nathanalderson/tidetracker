defmodule TidetrackerWeb.Router do
  use TidetrackerWeb, :router
  use AshAuthentication.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TidetrackerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
  end

  scope "/", TidetrackerWeb do
    pipe_through :browser

    live_session :default do
      live "/", HomeLive
    end

    sign_in_route path: "/login",
                  register_path: "/register",
                  reset_path: "/reset",
                  on_mount: [{TidetrackerWeb.Auth.LiveUserAuth, :live_no_user}],
                  layout: {TidetrackerWeb.Layouts, :barebones},
                  overrides: [TidetrackerWeb.Auth.Overrides, AshAuthentication.Phoenix.Overrides.Default]

    sign_out_route AuthController, "/logout",
      layout: {TidetrackerWeb.Layouts, :barebones},
      overrides: [TidetrackerWeb.Auth.Overrides, AshAuthentication.Phoenix.Overrides.Default]

    auth_routes_for Tidetracker.Accounts.User,
      to: AuthController,
      layout: {TidetrackerWeb.Layouts, :barebones},
      overrides: [TidetrackerWeb.Auth.Overrides, AshAuthentication.Phoenix.Overrides.Default]

    reset_route layout: {TidetrackerWeb.Layouts, :barebones},
                overrides: [TidetrackerWeb.Auth.Overrides, AshAuthentication.Phoenix.Overrides.Default]
  end

  scope "/admin", TidetrackerWeb.Admin, assigns: %{page_title: "Admin"} do
    pipe_through [:browser]

    ash_authentication_live_session :admin,
      on_mount: {TidetrackerWeb.Auth.LiveUserAuth, :live_user_required},
      layout: {TidetrackerWeb.Layouts, :admin} do
      live "/", AdminLive
      live "/meets", MeetsLive
      live "/meet/:meet_id", MeetLive, :view
      live "/meet/:meet_id/edit", MeetLive, :edit
    end
  end

  scope "/" do
    pipe_through :browser

    ash_admin_csp_nonce_assign_key = %{
      img: "ash_admin-Ed55GFnX",
      style: "ash_admin-Ed55GFnX",
      script: "ash_admin-Ed55GFnX"
    }

    ash_authentication_live_session :ash_admin,
      on_mount: {TidetrackerWeb.Auth.LiveUserAuth, :live_user_required},
      session: {AshAdmin.Router, :__session__, [%{"prefix" => "/ash-admin"}, []]},
      root_layout: {AshAdmin.Layouts, :root} do
      live "/ash-admin/*route", AshAdmin.PageLive, :page,
        private: %{live_socket_path: "/live", ash_admin_csp_nonce: ash_admin_csp_nonce_assign_key}
    end
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
