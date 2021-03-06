defmodule Flights.Bookings.CreateTest do
  use ExUnit.Case

  import Flights.Factory

  alias Flights.Bookings.Create
  alias Flights.Users.Agent, as: UserAgent
  alias Flights.Users.User

  describe "call/2" do
    setup do
      Flights.start_agents()

      %User{id: user_id} = user = build(:user)

      UserAgent.save(user)

      {:ok, user_id: user_id}
    end

    test "when all params are valid, create a booking", %{user_id: user_id} do
      params = %{city_origin: "Recife", city_destiny: "Gramado", complete_date: NaiveDateTime.local_now()}

      response = Create.call(user_id, params)

      assert {:ok, _uuid} = response
    end

    test "when an inexistent user is given, returns an error" do
      user_id = "0000000000000"
      params = %{city_origin: "Recife", city_destiny: "Gramado", complete_date: NaiveDateTime.local_now()}

      response = Create.call(user_id, params)

      expected_response = {:error, "User not found"}

      assert response == expected_response
    end

    test "when there is some invalid param, returns an error", %{user_id: user_id} do
      params = %{city_origin: "Recife", city_destiny: 123, complete_date: NaiveDateTime.local_now()}

      response = Create.call(user_id, params)

      expected_response = {:error, "Invalid city destiny"}

      assert response == expected_response
    end
  end
end
