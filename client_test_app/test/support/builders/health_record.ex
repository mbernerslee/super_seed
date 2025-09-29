defmodule ClientTestApp.Support.Builders.HealthRecord do
  @behaviour ClientTestApp.Support.Builder

  alias ClientTestApp.Repo
  alias ClientTestApp.Schemas.HealthRecord

  @impl true
  def build do
    record_date = Faker.Date.between(~D[2023-01-01], ~D[2024-12-31])

    %HealthRecord{
      record_date: record_date,
      record_type: Enum.random(["checkup", "vaccination", "treatment", "surgery", "injury"]),
      description: Faker.Lorem.sentence(),
      veterinarian: Faker.Person.name(),
      treatment: Faker.Lorem.sentence(),
      medication: Faker.Commerce.product_name(),
      dosage: "#{:rand.uniform(100)}mg",
      cost: Decimal.new(:rand.uniform(500) + 50),
      follow_up_date: Date.add(record_date, :rand.uniform(60) + 7),
      notes: Faker.Lorem.sentence()
    }
  end

  @impl true
  def insert!(health_record) do
    Repo.insert!(health_record)
  end

  @impl true
  def insert!, do: insert!(build())

  def with_record_date(health_record, date), do: %{health_record | record_date: date}
  def with_record_type(health_record, type), do: %{health_record | record_type: type}
  def with_description(health_record, description), do: %{health_record | description: description}
  def with_veterinarian(health_record, vet), do: %{health_record | veterinarian: vet}
  def with_treatment(health_record, treatment), do: %{health_record | treatment: treatment}
  def with_medication(health_record, medication), do: %{health_record | medication: medication}
  def with_dosage(health_record, dosage), do: %{health_record | dosage: dosage}
  def with_cost(health_record, cost), do: %{health_record | cost: cost}
  def with_follow_up_date(health_record, date), do: %{health_record | follow_up_date: date}
  def with_notes(health_record, notes), do: %{health_record | notes: notes}
  def with_animal_id(health_record, animal_id), do: %{health_record | animal_id: animal_id}
end
