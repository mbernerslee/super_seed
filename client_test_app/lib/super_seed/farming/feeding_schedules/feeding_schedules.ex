defmodule ClientTestApp.SuperSeed.Farming.FeedingSchedules do
  @behaviour SuperSeed.Inserter

  alias ClientTestApp.Support.Builders.FeedingSchedule
  alias ClientTestApp.SuperSeed.Farming.Animals.Bessie
  alias ClientTestApp.SuperSeed.Farming.FeedTypes.Hay

  @name "Morning Feed Schedule"

  def name, do: @name

  @impl true
  def table, do: "feeding_schedules"

  @impl true
  def depends_on, do: [{:inserter, Bessie}, {:inserter, Hay}]

  @impl true
  def insert(%{Bessie => animal, Hay => feed_type}) do
    FeedingSchedule.build()
    |> FeedingSchedule.with_feeding_time(~T[07:00:00])
    |> FeedingSchedule.with_quantity_kg(Decimal.new("5.0"))
    |> FeedingSchedule.with_start_date(~D[2024-01-01])
    |> FeedingSchedule.with_animal_id(animal.id)
    |> FeedingSchedule.with_feed_type_id(feed_type.id)
    |> FeedingSchedule.insert!()
  end
end
