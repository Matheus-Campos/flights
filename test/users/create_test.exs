defmodule Flights.Users.CreateTest do
  use ExUnit.Case

  alias Flights.Users.Agent, as: UserAgent
  alias Flights.Users.Create

  describe "call/1" do
    setup do
      UserAgent.start_link(nil)

      :ok
    end

    test "should create a user" do
      params = %{name: "Matheus Campos", email: "silva.campos.matheus@gmail.com", cpf: "78945612300"}

      response = Create.call(params)

      assert {:ok, _uuid} = response
    end

    test "should not create a user with invalid params" do
      email = "silva.campos.matheusgmail.com"
      params = %{name: "Matheus Campos", email: email, cpf: "78945612300"}

      response = Create.call(params)

      assert {:error, _reason} = response
    end
  end
end
