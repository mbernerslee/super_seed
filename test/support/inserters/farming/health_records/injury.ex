defmodule SuperSeed.Support.Inserters.Farming.HealthRecords.Injury do
  @behaviour SuperSeed.Inserter

  alias SuperSeed.Support.Builders.HealthRecord
  alias SuperSeed.Support.Inserters.Farming.Animals.Dolly

  @name "Minor Injury Treatment"

  def name, do: @name

  @impl true
  def table, do: "health_records"

  @impl true
  def depends_on, do: [{:table, "animals"}]

  @impl true
  def insert(%{Dolly => animal}) do
    HealthRecord.build()
    |> HealthRecord.with_record_date(~D[2024-04-05])
    |> HealthRecord.with_record_type("injury")
    |> HealthRecord.with_description("Cut on leg from fence wire")
    |> HealthRecord.with_veterinarian("Dr. Brown")
    |> HealthRecord.with_treatment("Wound cleaning and bandaging")
    |> HealthRecord.with_medication("Antiseptic spray")
    |> HealthRecord.with_cost(Decimal.new("85.00"))
    |> HealthRecord.with_animal_id(animal.id)
    |> HealthRecord.insert!()
  end
end