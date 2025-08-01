defmodule SuperSeed.Support.Builders.FeedingSchedule do
  @behaviour SuperSeed.Support.Builder

  alias SuperSeed.Repo
  alias SuperSeed.Support.Schemas.FeedingSchedule

  @impl true
  def build do
    start_date = Faker.Date.between(~D[2024-01-01], ~D[2024-06-30])
    
    %FeedingSchedule{
      quantity_kg: Decimal.new(:rand.uniform(20) + 1),
      feeding_time: Time.new!(:rand.uniform(24), :rand.uniform(60), 0),
      frequency_per_day: :rand.uniform(4) + 1,
      start_date: start_date,
      end_date: Date.add(start_date, :rand.uniform(180) + 30),
      notes: Faker.Lorem.sentence()
    }
  end

  @impl true
  def insert!(feeding_schedule) do
    Repo.insert!(feeding_schedule)
  end

  @impl true
  def insert!, do: insert!(build())

  def with_quantity_kg(feeding_schedule, quantity), do: %{feeding_schedule | quantity_kg: quantity}
  def with_feeding_time(feeding_schedule, time), do: %{feeding_schedule | feeding_time: time}
  def with_frequency_per_day(feeding_schedule, frequency), do: %{feeding_schedule | frequency_per_day: frequency}
  def with_start_date(feeding_schedule, start_date), do: %{feeding_schedule | start_date: start_date}
  def with_end_date(feeding_schedule, end_date), do: %{feeding_schedule | end_date: end_date}
  def with_notes(feeding_schedule, notes), do: %{feeding_schedule | notes: notes}
  def with_animal_id(feeding_schedule, animal_id), do: %{feeding_schedule | animal_id: animal_id}
  def with_feed_type_id(feeding_schedule, feed_type_id), do: %{feeding_schedule | feed_type_id: feed_type_id}
end