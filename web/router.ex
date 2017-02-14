defmodule PhoneHome.Router do
  use PhoneHome.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]

    scope "/api" do
      scope "/v1", PhoneHome do
        post "/check_in", SmsController, :check_in
      end
    end
  end

  scope "/", PhoneHome do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/notes", NoteController, [:index, :new, :create, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoneHome do
    #   pipe_through :api
    # end
end
