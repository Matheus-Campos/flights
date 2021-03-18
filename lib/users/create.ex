defmodule Flights.Users.Create do
  alias Flights.Users.User
  alias Flights.Users.Agent, as: UserAgent

  def call(%{name: name, email: email, cpf: cpf}) do
    with {:ok, %User{id: user_id} = user} <- User.build(name, email, cpf),
         {:ok, _user} = UserAgent.save(user)
         do
      {:ok, user_id}
    end
  end
end
