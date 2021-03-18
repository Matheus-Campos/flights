defmodule Flights.Bookings.Agent do
  use Agent

  alias Flights.Bookings.Booking

  def start_link(_arg) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%Booking{id: booking_id} = booking) do
    {
      Agent.update(__MODULE__, fn state -> Map.put(state, booking_id, booking) end),
      booking
    }
  end

  def get(booking_id) do
    Agent.get(__MODULE__, &get_booking(&1, booking_id))
  end

  defp get_booking(state, booking_id) do
    case Map.get(state, booking_id) do
      nil -> {:error, "Booking not found"}
      booking -> {:ok, booking}
    end
  end
end
