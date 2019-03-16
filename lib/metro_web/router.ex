defmodule MetroWeb.Router do
  use MetroWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MetroWeb do
    pipe_through :browser # Use the default browser stack

    resources "/books", BookController
    resources "/authors", AuthorController
    resources "/events", EventController
    resources "/rooms", RoomController
    resources "/copies", CopyController
    resources "/libraries", LibraryController

    resources "/cards", CardController

    resources "/transit", TransitController
    resources "/waitlist", WaitlistController
    resources "/reservation", ReservationController
    resources "/checkouts", CheckoutController

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", MetroWeb do
  #   pipe_through :api
  # end
end
