defmodule Flights do
  alias Flights.Users.Agent, as: UserAgent
  alias Flights.Bookings.Agent, as: BookingAgent
  alias Flights.Bookings.Create, as: CreateBooking
  alias Flights.Bookings.Report
  alias Flights.Users.Create, as: CreateUser

  def start_agents() do
    UserAgent.start_link(nil)
    BookingAgent.start_link(nil)
  end

  defdelegate create_user(params), to: CreateUser, as: :call

  defdelegate create_booking(user_id, params), to: CreateBooking, as: :call

  defdelegate get_booking(booking_id), to: BookingAgent, as: :get

  defdelegate generate_report(from_date, to_date), to: Report, as: :call
end
