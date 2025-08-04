defmodule SuperSeed.Support.Schemas.FeedingSchedule do
  use Ecto.Schema

  schema "feeding_schedules" do
    field :quantity_kg, :decimal
    field :feeding_time, :time
    field :frequency_per_day, :integer, default: 1
    field :start_date, :date
    field :end_date, :date
    field :notes, :string

    belongs_to :animal, SuperSeed.Support.Schemas.Animal
    belongs_to :feed_type, SuperSeed.Support.Schemas.FeedType

    timestamps type: :utc_datetime
  end
end
