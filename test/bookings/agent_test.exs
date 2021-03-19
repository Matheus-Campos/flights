defmodule Flights.Bookings.AgentTest do
  use ExUnit.Case

  import Flights.Factory

  alias Flights.Bookings.Agent, as: BookingAgent
  alias Flights.Bookings.Booking

  describe "save/1" do
    setup do
      BookingAgent.start_link(nil)

      booking = build(:booking)

      {:ok, booking: booking}
    end

    test "should save a booking", %{booking: booking} do
      response = BookingAgent.save(booking)

      expected_response = {:ok, booking}

      assert response == expected_response
    end
  end

  describe "get/1" do
    setup do
      BookingAgent.start_link(nil)

      :ok
    end

    test "when the booking is found, returns the booking" do
      %Booking{id: booking_id} = booking = build(:booking)

      BookingAgent.save(booking)

      response = BookingAgent.get(booking_id)

      expected_response = {:ok, booking}

      assert response == expected_response
    end

    test "when the booking is not found, returns an error" do
      booking_id = "00000000000"

      response = BookingAgent.get(booking_id)

      expected_response = {:error, "Flight Booking not found"}

      assert response == expected_response
    end
  end

  describe "get_between_dates/2" do
    setup do
      BookingAgent.start_link(nil)

      :ok
    end

    test "should return all bookings between the given dates" do
      {:ok, from_date} = NaiveDateTime.new(2021, 3, 18, 0, 0, 0)
      {:ok, to_date} = NaiveDateTime.new(2021, 3, 19, 0, 0, 0)

      booking1 = build(:booking, complete_date: from_date)
      booking2 = build(:booking, complete_date: to_date)
      booking3 = build(:booking, complete_date: ~N[2021-03-20 00:00:00])

      BookingAgent.save(booking1)
      BookingAgent.save(booking2)
      BookingAgent.save(booking3)

      response = BookingAgent.get_between_dates(from_date, to_date)

      expected_response = {:ok, [booking1, booking2]}

      assert response == expected_response
    end

    test "when from_date and to_date make an invalid range, returns an error" do
      {:ok, from_date} = NaiveDateTime.new(2021, 3, 19, 0, 0, 0)
      {:ok, to_date} = NaiveDateTime.new(2021, 3, 18, 0, 0, 0)

      response = BookingAgent.get_between_dates(from_date, to_date)

      expected_response = {:error, "Invalid date range"}

      assert response == expected_response
    end
  end
end
