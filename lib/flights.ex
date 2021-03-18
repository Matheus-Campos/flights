defmodule Flights do
  alias Flights.Users.Agent, as: UserAgent
  alias Flights.Bookings.Agent, as: BookingAgent

  alias Flights.Users.Create, as: CreateUser

  def start_agents() do
    UserAgent.start_link(nil)
    BookingAgent.start_link(nil)
  end

  defdelegate create_user(params), to: CreateUser, as: :call

  def hello do
    :world
  end
end
