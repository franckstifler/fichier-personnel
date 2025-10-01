defmodule EduCountWeb.Router do
  use EduCountWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {EduCountWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EduCountWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/config", EduCountWeb do
    pipe_through :browser

    live "/regions", RegionLive.Index, :index
    live "/regions/new", RegionLive.Form, :new
    live "/regions/:id/edit", RegionLive.Form, :edit

    live "/regions/:id", RegionLive.Show, :show
    live "/regions/:id/show/edit", RegionLive.Show, :edit

    live "/divisions", DivisionLive.Index, :index
    live "/divisions/new", DivisionLive.Form, :new
    live "/divisions/:id/edit", DivisionLive.Form, :edit

    live "/divisions/:id", DivisionLive.Show, :show
    live "/divisions/:id/show/edit", DivisionLive.Show, :edit

    # SubDivisions
    live "/sub_divisions", SubDivisionLive.Index, :index
    live "/sub_divisions/new", SubDivisionLive.Form, :new
    live "/sub_divisions/:id/edit", SubDivisionLive.Form, :edit

    live "/sub_divisions/:id", SubDivisionLive.Show, :show
    live "/sub_divisions/:id/show/edit", SubDivisionLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", EduCountWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:edu_count, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: EduCountWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  if Application.compile_env(:edu_count, :dev_routes) do
    import AshAdmin.Router

    scope "/admin" do
      pipe_through :browser

      ash_admin "/"
    end
  end
end
