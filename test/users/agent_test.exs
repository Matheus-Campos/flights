defmodule Flights.Users.AgentTest do
  use ExUnit.Case

  import Flights.Factory

  alias Flights.Users.Agent, as: UserAgent
  alias Flights.Users.User

  describe "save/1" do
    test "should save a user" do
      user = build(:user)

      UserAgent.start_link(nil)

      response = UserAgent.save(user)

      expected_response = {:ok, user}

      assert response == expected_response
    end
  end

  describe "get/1" do
    setup do
      UserAgent.start_link(nil)

      :ok
    end

    test "when the user is found, returns the user" do
      %User{id: user_id} = user = build(:user)

      UserAgent.save(user)

      response = UserAgent.get(user_id)

      expected_response = {:ok, user}

      assert response == expected_response
    end

    test "when the user is not found, returns an error" do
      response = UserAgent.get("00000000000")

      expected_response = {:error, "User not found"}

      assert response == expected_response
    end
  end
end
