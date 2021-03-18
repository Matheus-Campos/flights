defmodule Flights.Factory do
  use ExMachina

  alias Flights.Bookings.Booking
  alias Flights.Users.User

  def user_factory do
    %User{
      name: "Matheus Campos",
      email: "silva.campos.matheus@gmail.com",
      cpf: "78945612300",
      id: UUID.uuid4()
    }
  end

  def booking_factory do
    %User{id: user_id} = build(:user)

    %Booking{
      complete_date: NaiveDateTime.local_now(),
      city_origin: "Recife",
      city_destiny: "Gramado",
      id: UUID.uuid4(),
      user_id: user_id
    }
  end
end
