defmodule Flights.Bookings.BookingTest do
  use ExUnit.Case

  alias Flights.Bookings.Booking
  alias Flights.Users.Agent, as: UserAgent
  alias Flights.Users.User

  describe "build/4" do
    setup do
      UserAgent.start_link(nil)

      {:ok, user} = User.build("Matheus Campos", "silva.campos.matheus@gmail.com", "78945612300")

      UserAgent.save(user)

      {:ok, user: user}
    end

    test "when all params are valid, returns a booking", %{user: %User{id: user_id}} do
      complete_date = NaiveDateTime.local_now()
      city_origin = "Recife"
      city_destiny = "Gramado"

      response = Booking.build(complete_date, city_origin, city_destiny, user_id)

      assert {:ok, %Booking{
        complete_date: ^complete_date,
        city_origin: ^city_origin,
        city_destiny: ^city_destiny,
        user_id: ^user_id,
        id: _id
      }} = response
    end

    test "when city origin is invalid, returns an error", %{user: %User{id: user_id}} do
      complete_date = NaiveDateTime.local_now()
      city_origin = nil
      city_destiny = "Gramado"

      response = Booking.build(complete_date, city_origin, city_destiny, user_id)

      expected_response = {:error, "Invalid city origin"}

      assert response == expected_response
    end

    test "when city destiny is invalid, returns an error", %{user: %User{id: user_id}} do
      complete_date = NaiveDateTime.local_now()
      city_origin = "Recife"
      city_destiny = ""

      response = Booking.build(complete_date, city_origin, city_destiny, user_id)

      expected_response = {:error, "Invalid city destiny"}

      assert response == expected_response
    end

    test "when date is invalid, returns an error", %{user: %User{id: user_id}} do
      complete_date = Date.new(2021, 3, 18)
      city_origin = "Recife"
      city_destiny = "Gramado"

      response = Booking.build(complete_date, city_origin, city_destiny, user_id)

      expected_response = {:error, "Invalid date"}

      assert response == expected_response
    end

    test "when the user is not found, returns an error" do
      user_id = "00000000000"
      complete_date = NaiveDateTime.local_now()
      city_origin = "Recife"
      city_destiny = "Gramado"

      response = Booking.build(complete_date, city_origin, city_destiny, user_id)

      expected_response = {:error, "User not found"}

      assert response == expected_response
    end
  end
end
