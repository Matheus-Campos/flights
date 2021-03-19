defmodule Flights.Bookings.Report do
  alias Flights.Bookings.Agent, as: BookingAgent
  alias Flights.Bookings.Booking

  def call(%NaiveDateTime{} = from_date, %NaiveDateTime{} = to_date, file_name \\ "report.csv") do
    BookingAgent.get_between_dates(from_date, to_date)
    |> create_report(file_name)
  end

  defp create_report({:ok, bookings}, file_name) do
    rows = Enum.map(bookings, &booking_string(&1))

    File.write(file_name, rows)
    |> handle_file_write()
  end

  defp create_report({:error, _reason} = error, _file_name), do: error

  defp handle_file_write({:error, _reason} = error), do: error
  defp handle_file_write(:ok), do: {:ok, "Report generated successfully"}

  defp booking_string(%Booking{
    user_id: user_id,
    city_origin: city_origin,
    city_destiny: city_destiny,
    complete_date: complete_date
    }) do
      "#{user_id},#{city_origin},#{city_destiny},#{complete_date}\n"
  end
end
