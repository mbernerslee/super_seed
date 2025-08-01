defmodule SuperSeed.Support.Inserters.Farming.HealthRecords.Checkup do
  @behaviour SuperSeed.Inserter

  alias SuperSeed.Support.Builders.HealthRecord
  alias SuperSeed.Support.Inserters.Farming.Animals.Bessie

  @name "Annual Checkup"

  def name, do: @name

  @impl true
  def table, do: "health_records"

  @impl true
  def depends_on, do: [{:inserter, Bessie}]

  @impl true
  def insert(%{Bessie => animal}) do
    HealthRecord.build()
    |> HealthRecord.with_record_date(~D[2024-01-15])
    |> HealthRecord.with_record_type("checkup")
    |> HealthRecord.with_description("Annual health checkup")
    |> HealthRecord.with_veterinarian("Dr. Johnson")
    |> HealthRecord.with_cost(Decimal.new("150.00"))
    |> HealthRecord.with_animal_id(animal.id)
    |> HealthRecord.insert!()
  end
end