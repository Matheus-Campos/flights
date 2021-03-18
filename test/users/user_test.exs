defmodule Flights.Users.UserTest do
  use ExUnit.Case

  alias Flights.Users.User

  describe "build/3" do
    setup do
      cpf = "78945612300"
      name = "Matheus Campos"
      email = "silva.campos.matheus@gmail.com"

      {:ok, cpf: cpf, name: name, email: email}
    end

    test "when all params are valid, returns a user", %{cpf: cpf, name: name, email: email} do
      response = User.build(name, email, cpf)

      assert {:ok, %User{cpf: ^cpf, email: ^email, name: ^name, id: _id}} = response
    end

    test "when name is invalid, returns an error", %{cpf: cpf, email: email} do
      response = User.build("", email, cpf)

      assert response == {:error, "Invalid name"}
    end

    test "when email is invalid, returns an error", %{name: name, cpf: cpf} do
      response = User.build(name, 123, cpf)

      assert response == {:error, "Invalid email"}
    end

    test "when cpf is invalid, returns an error", %{name: name, email: email} do
      response = User.build(name, email, "4561234")

      assert response == {:error, "Invalid cpf"}
    end
  end
end
