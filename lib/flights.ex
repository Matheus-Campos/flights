defmodule Flights do
  alias Flights.Users.Agent, as: UserAgent
  alias Flights.Bookings.Agent, as: BookingAgent
  alias Flights.Bookings.Create, as: CreateBooking
  alias Flights.Users.Create, as: CreateUser

  def start_agents() do
    UserAgent.start_link(nil)
    BookingAgent.start_link(nil)
  end

  defdelegate create_user(params), to: CreateUser, as: :call
  defdelegate create_booking(user_id, params), to: CreateBooking, as: :call
end
