defmodule ClientTestApp.Schemas.FeedingSchedule do
  use Ecto.Schema

  schema "feeding_schedules" do
    field(:quantity_kg, :decimal)
    field(:feeding_time, :time)
    field(:frequency_per_day, :integer, default: 1)
    field(:start_date, :date)
    field(:end_date, :date)
    field(:notes, :string)

    belongs_to(:animal, ClientTestApp.Schemas.Animal)
    belongs_to(:feed_type, ClientTestApp.Schemas.FeedType)

    timestamps(type: :utc_datetime)
  end
end
