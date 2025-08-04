defmodule SuperSeed.Support.Inserters.Farming.HealthRecords.Vaccination do
  @behaviour SuperSeed.Inserter

  alias SuperSeed.Support.Builders.HealthRecord
  alias SuperSeed.Support.Inserters.Farming.Animals.Bessie

  @name "Rabies Vaccination"

  def name, do: @name

  @impl true
  def table, do: "health_records"

  @impl true
  def depends_on, do: [{:table, "animals"}]

  @impl true
  def insert(%{Bessie => animal}) do
    HealthRecord.build()
    |> HealthRecord.with_record_date(~D[2024-02-01])
    |> HealthRecord.with_record_type("vaccination")
    |> HealthRecord.with_description("Annual rabies vaccination")
    |> HealthRecord.with_veterinarian("Dr. Smith")
    |> HealthRecord.with_medication("Rabies vaccine")
    |> HealthRecord.with_dosage("1ml")
    |> HealthRecord.with_cost(Decimal.new("45.00"))
    |> HealthRecord.with_animal_id(animal.id)
    |> HealthRecord.insert!()
  end
end
