defmodule Flights.Bookings.Create do
  alias Flights.Bookings.Agent, as: BookingAgent
  alias Flights.Bookings.Booking

  def call(user_id, %{complete_date: complete_date, city_origin: city_origin, city_destiny: city_destiny}) do
    with {:ok, %Booking{id: booking_id} = booking} <- Booking.build(complete_date, city_origin, city_destiny, user_id),
         {:ok, _booking} <- BookingAgent.save(booking)
         do
      {:ok, booking_id}
    end
  end
end
