defmodule Flights.Users.Agent do
  use Agent

  alias Flights.Users.User

  def start_link(_arg) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%User{id: user_id} = user) do
    {
      Agent.update(__MODULE__, fn state -> Map.put(state, user_id, user) end),
      user
    }
  end

  def get(user_id) do
    Agent.get(__MODULE__, &get_user(&1, user_id))
  end

  defp get_user(state, user_id) do
    case Map.get(state, user_id) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end
end
