defmodule FlightsTest do
  use ExUnit.Case

  import Flights.Factory

  alias Flights.Bookings.Agent, as: BookingAgent
  alias Flights.Bookings.Booking
  alias Flights.Users.Agent, as: UserAgent
  alias Flights.Users.User

  describe "create_user/1" do
    test "when all params are valid, creates a user" do
      Flights.start_agents()

      params = %{name: "Matheus Campos", email: "silva.campos.matheus@gmail.com", cpf: "78945612300"}

      response = Flights.create_user(params)

      assert {:ok, _user_id} = response
    end
  end

  describe "create_booking/1" do
    setup do
      Flights.start_agents()

      params = %{city_origin: "Recife", city_destiny: "Gramado", complete_date: NaiveDateTime.local_now()}

      {:ok, params: params}
    end

    test "when all params are valid, creates a booking", %{params: params} do
      %User{id: user_id} = user = build(:user)

      UserAgent.save(user)

      response = Flights.create_booking(user_id, params)

      assert {:ok, _booking_id} = response
    end

    test "when user does not exists, returns an error", %{params: params} do
      user_id = "0000000000"

      response = Flights.create_booking(user_id, params)

      expected_response = {:error, "User not found"}

      assert response == expected_response
    end
  end

  describe "get_booking/1" do
    setup do
      Flights.start_agents()
      :ok
    end

    test "when a booking exists, returns it" do
      %Booking{id: booking_id} = booking = build(:booking)

      BookingAgent.save(booking)

      response = Flights.get_booking(booking_id)

      expected_response = {:ok, booking}

      assert response == expected_response
    end

    test "when a booking is not found, returns an error" do
      booking_id = "00000000000"

      response = Flights.get_booking(booking_id)

      expected_response = {:error, "Flight Booking not found"}

      assert response == expected_response
    end
  end

  describe "generate_report/3" do
    test "generate a report from facade" do
      Flights.start_agents()

      {:ok, from_date} = NaiveDateTime.new(2021, 3, 18, 0, 0, 0)
      {:ok, to_date} = NaiveDateTime.new(2021, 3, 19, 0, 0, 0)

      %Booking{user_id: user_id1} = booking1 = build(:booking, complete_date: from_date)
      %Booking{user_id: user_id2} = booking2 = build(:booking, complete_date: to_date)
      booking3 = build(:booking, complete_date: ~N[2021-03-20 00:00:00])

      BookingAgent.save(booking1)
      BookingAgent.save(booking2)
      BookingAgent.save(booking3)

      response = Flights.generate_report(from_date, to_date)

      expected_response = {:ok, "Report generated successfully"}

      assert response == expected_response

      file_content = File.read!("report.csv")

      assert file_content == "#{user_id1},Recife,Gramado,2021-03-18 00:00:00\n" <>
                             "#{user_id2},Recife,Gramado,2021-03-19 00:00:00\n"
    end
  end
end
