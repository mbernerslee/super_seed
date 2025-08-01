defmodule SuperSeed.Support.Builders.Animal do
  @behaviour SuperSeed.Support.Builder

  alias SuperSeed.Repo
  alias SuperSeed.Support.Schemas.Animal

  @impl true
  def build do
    %Animal{
      name: Faker.Person.first_name(),
      tag_number: "TAG-#{:rand.uniform(9999)}",
      birth_date: Faker.Date.between(~D[2020-01-01], ~D[2023-12-31]),
      gender: Enum.random(["male", "female"]),
      weight_kg: Decimal.new(:rand.uniform(300) + 50),
      health_status: Enum.random(["healthy", "sick", "quarantine", "recovery"]),
      notes: Faker.Lorem.sentence()
    }
  end

  @impl true
  def insert!(animal) do
    Repo.insert!(animal)
  end

  @impl true
  def insert!, do: insert!(build())

  def with_name(animal, name), do: %{animal | name: name}
  def with_tag_number(animal, tag_number), do: %{animal | tag_number: tag_number}
  def with_birth_date(animal, birth_date), do: %{animal | birth_date: birth_date}
  def with_gender(animal, gender), do: %{animal | gender: gender}
  def with_weight_kg(animal, weight), do: %{animal | weight_kg: weight}
  def with_health_status(animal, status), do: %{animal | health_status: status}
  def with_notes(animal, notes), do: %{animal | notes: notes}
  def with_farm_id(animal, farm_id), do: %{animal | farm_id: farm_id}
  def with_animal_type_id(animal, animal_type_id), do: %{animal | animal_type_id: animal_type_id}
  def with_mother_id(animal, mother_id), do: %{animal | mother_id: mother_id}
  def with_father_id(animal, father_id), do: %{animal | father_id: father_id}
end
