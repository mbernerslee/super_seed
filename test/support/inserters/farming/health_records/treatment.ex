defmodule SuperSeed.Support.Inserters.Farming.HealthRecords.Treatment do
  @behaviour SuperSeed.Inserter

  alias SuperSeed.Support.Builders.HealthRecord
  alias SuperSeed.Support.Inserters.Farming.Animals.Thunder

  @name "Hoof Treatment"

  def name, do: @name

  @impl true
  def table, do: "health_records"

  @impl true
  def depends_on, do: [{:inserter, Thunder}]

  @impl true
  def insert(%{Thunder => animal}) do
    HealthRecord.build()
    |> HealthRecord.with_record_date(~D[2024-03-10])
    |> HealthRecord.with_record_type("treatment")
    |> HealthRecord.with_description("Hoof trimming and treatment for infection")
    |> HealthRecord.with_veterinarian("Dr. Wilson")
    |> HealthRecord.with_treatment("Hoof trimming and antibiotic treatment")
    |> HealthRecord.with_medication("Penicillin")
    |> HealthRecord.with_dosage("10ml daily for 7 days")
    |> HealthRecord.with_cost(Decimal.new("275.00"))
    |> HealthRecord.with_animal_id(animal.id)
    |> HealthRecord.insert!()
  end
end
