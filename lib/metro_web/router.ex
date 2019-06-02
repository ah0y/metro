defmodule MetroWeb.Router do
  use MetroWeb, :router
  use Coherence.Router

  @user_schema Application.get_env(:coherence, :user_schema)
  @id_key Application.get_env(:coherence, :schema_key)

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session  # Add this
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true
  end

  scope "/" do
    pipe_through :browser
    coherence_routes()
  end

  scope "/" do
    pipe_through :protected
    coherence_routes :protected
  end

  scope "/", MetroWeb do
    pipe_through :browser # Use the default browser stack

    resources "/books", BookController, param: "isbn"
    resources "/authors", AuthorController
    resources "/events", EventController
    resources "/rooms", RoomController
    resources "/copies", CopyController
    resources "/libraries", LibraryController

    resources "/users", UserController
    resources "/cards", CardController

    resources "/transit", TransitController
    resources "/waitlist", WaitlistController
    resources "/reservation", ReservationController
    resources "/checkouts", CheckoutController
    put "/process/:id", CheckoutController, :process

    get "/", PageController, :index
  end

  scope "/", MetroWeb do
    pipe_through :protected

    # add protected resources below
  end

  # Other scopes may use custom stacks.
  # scope "/api", MetroWeb do
  #   pipe_through :api
  # end
end
