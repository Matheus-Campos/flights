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

  def get_between_dates(%NaiveDateTime{} = from_date, %NaiveDateTime{} = to_date) do
    case NaiveDateTime.compare(from_date, to_date) do
      :gt -> {:error, "Invalid date range"}
      _ -> {:ok, Agent.get(__MODULE__, &get_bookings_by_date_range(&1, from_date, to_date))}
    end
  end

  defp get_bookings_by_date_range(state, from_date, to_date) do
    state
    |> Map.values()
    |> Stream.filter(&filter_bookings_by_date_range(&1, from_date, to_date))
    |> Enum.sort_by(&Map.get(&1, :complete_date), :asc)
  end

  defp filter_bookings_by_date_range(%Booking{complete_date: date}, from_date, to_date) do
    NaiveDateTime.compare(date, from_date) in [:eq, :gt] and NaiveDateTime.compare(date, to_date) in [:eq, :lt]
  end

  defp get_booking(state, booking_id) do
    case Map.get(state, booking_id) do
      nil -> {:error, "Flight Booking not found"}
      booking -> {:ok, booking}
    end
  end
end
