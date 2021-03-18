defmodule Flights.Users.User do
  @keys [:id, :name, :email, :cpf]
  @cpf_length 11
  @enforce_keys @keys

  defstruct @keys

  def build(_name, _email, cpf) when not is_bitstring(cpf), do: {:error, "Invalid cpf"}

  def build(name, _email, _cpf) when not is_bitstring(name), do: {:error, "Invalid name"}

  def build(_name, email, _cpf) when not is_bitstring(email), do: {:error, "Invalid email"}

  def build(name, email, cpf) do
    cond do
      String.length(cpf) != @cpf_length -> build(name, email, nil)
      String.length(name) == 0 -> build(nil, email, cpf)
      String.length(email) == 0 or not (String.contains?(email, "@") and String.contains?(email, ".")) -> build(name, nil, cpf)

      true -> {:ok ,%__MODULE__{
        id: UUID.uuid4(),
        name: name,
        email: email,
        cpf: cpf
      }}
    end
  end
end
