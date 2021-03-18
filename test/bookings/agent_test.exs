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

      expected_response = {:error, "Booking not found"}

      assert response == expected_response
    end
  end
end
