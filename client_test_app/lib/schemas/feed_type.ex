defmodule ClientTestApp.Schemas.FeedType do
  use Ecto.Schema

  schema "feed_types" do
    field(:name, :string)
    field(:brand, :string)
    field(:feed_category, :string)
    field(:protein_percentage, :decimal)
    field(:fat_percentage, :decimal)
    field(:fiber_percentage, :decimal)
    field(:calories_per_kg, :integer)
    field(:cost_per_kg, :decimal)
    field(:supplier, :string)
    field(:description, :string)

    has_many(:feeding_schedules, ClientTestApp.Schemas.FeedingSchedule)
    has_many(:feed_inventory, ClientTestApp.Schemas.FeedInventory)

    timestamps(type: :utc_datetime)
  end
end
