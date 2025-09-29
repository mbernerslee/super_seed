defmodule ClientTestApp.Support.Builders.AnimalType do
  @behaviour ClientTestApp.Support.Builder

  alias ClientTestApp.Repo
  alias ClientTestApp.Schemas.AnimalType

  @impl true
  def build do
    %AnimalType{
      name: Faker.Person.first_name(),
      species: Enum.random(["cattle", "pig", "sheep", "goat", "chicken", "horse"]),
      breed: Faker.Company.name(),
      typical_weight_kg: Decimal.new(:rand.uniform(500) + 50),
      gestation_days: :rand.uniform(300) + 100,
      life_expectancy_years: :rand.uniform(20) + 5,
      description: Faker.Lorem.sentence()
    }
  end

  @impl true
  def insert!(animal_type) do
    Repo.insert!(animal_type)
  end

  @impl true
  def insert!, do: insert!(build())

  def with_name(animal_type, name), do: %{animal_type | name: name}
  def with_species(animal_type, species), do: %{animal_type | species: species}
  def with_breed(animal_type, breed), do: %{animal_type | breed: breed}
  def with_typical_weight_kg(animal_type, weight), do: %{animal_type | typical_weight_kg: weight}
  def with_gestation_days(animal_type, days), do: %{animal_type | gestation_days: days}
  def with_life_expectancy_years(animal_type, years), do: %{animal_type | life_expectancy_years: years}
  def with_description(animal_type, description), do: %{animal_type | description: description}
end
