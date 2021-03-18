defmodule Flights.Bookings.Booking do
  alias Flights.Users.Agent, as: UserAgent

  @keys [:id, :complete_date, :city_origin, :city_destiny, :user_id]
  @enforce_keys @keys

  defstruct @keys

  def build(_complete_date, city_origin, _city_destiny, _user_id) when not is_bitstring(city_origin), do: {:error, "Invalid city origin"}

  def build(_complete_date, _city_origin, city_destiny, _user_id) when not is_bitstring(city_destiny), do: {:error, "Invalid city destiny"}

  def build(complete_date, _city_origin, _city_destiny, _user_id) when not is_struct(complete_date), do: {:error, "Invalid date"}

  def build(%NaiveDateTime{} = complete_date, city_origin, city_destiny, user_id) do
    cond do
      String.length(city_origin) == 0 -> build(complete_date, nil, city_destiny, user_id)
      String.length(city_destiny) == 0 -> build(complete_date, city_origin, nil, user_id)
      true -> create_user(complete_date, city_origin, city_destiny, user_id)
    end
  end

  defp create_user(complete_date, city_origin, city_destiny, user_id) do
    with {:ok, _user} <- UserAgent.get(user_id) do
      {:ok, %__MODULE__{
        id: UUID.uuid4(),
        complete_date: complete_date,
        city_destiny: city_destiny,
        city_origin: city_origin,
        user_id: user_id
      }}
    end
  end
end
