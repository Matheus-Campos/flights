defmodule Flights.Bookings.ReportTest do
  use ExUnit.Case

  import Flights.Factory

  alias Flights.Bookings.Agent, as: BookingAgent
  alias Flights.Bookings.Booking
  alias Flights.Bookings.Report

  describe "call/3" do
    setup do
      BookingAgent.start_link(nil)

      {:ok, from_date} = NaiveDateTime.new(2021, 3, 18, 0, 0, 0)
      {:ok, to_date} = NaiveDateTime.new(2021, 3, 19, 0, 0, 0)

      booking1 = build(:booking, complete_date: from_date)
      booking2 = build(:booking, complete_date: to_date)
      booking3 = build(:booking, complete_date: ~N[2021-03-20 00:00:00])

      file_name = "report_test.csv"

      BookingAgent.save(booking1)
      BookingAgent.save(booking2)
      BookingAgent.save(booking3)

      {:ok, from_date: from_date, to_date: to_date, file_name: file_name, booking1: booking1, booking2: booking2}
    end

    test "generate a report successfully", %{
      from_date: from_date,
      to_date: to_date,
      file_name: file_name,
      booking1: %Booking{user_id: user_id1},
      booking2: %Booking{user_id: user_id2}
    } do
      response = Report.call(from_date, to_date, file_name)

      expected_response = {:ok, "Report generated successfully"}

      assert response == expected_response

      file_content = File.read!(file_name)

      assert file_content == "#{user_id1},Recife,Gramado,2021-03-18 00:00:00\n" <>
                             "#{user_id2},Recife,Gramado,2021-03-19 00:00:00\n"
    end

    test "returns an error when the date range is invalid", %{
      from_date: from_date,
      to_date: to_date,
      file_name: file_name
    } do
      response = Report.call(to_date, from_date, file_name)

      expected_response = {:error, "Invalid date range"}

      assert response == expected_response
    end
  end
end
