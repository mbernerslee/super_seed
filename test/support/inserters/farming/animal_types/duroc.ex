defmodule SuperSeed.Support.Inserters.Farming.AnimalTypes.Duroc do
  @behaviour SuperSeed.Inserter

  alias SuperSeed.Support.Builders.AnimalType

  @name "Duroc Pig"

  def name, do: @name

  @impl true
  def table, do: "animal_types"

  @impl true
  def depends_on, do: []

  @impl true
  def insert(_) do
    AnimalType.build()
    |> AnimalType.with_name(@name)
    |> AnimalType.with_species("pig")
    |> AnimalType.with_breed("Duroc")
    |> AnimalType.with_typical_weight_kg(Decimal.new("300"))
    |> AnimalType.with_gestation_days(114)
    |> AnimalType.with_life_expectancy_years(12)
    |> AnimalType.insert!()
  end
end