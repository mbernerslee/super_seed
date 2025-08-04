defmodule SuperSeed.Support.Inserters.Farming.AnimalTypes.Merino do
  @behaviour SuperSeed.Inserter

  alias SuperSeed.Support.Builders.AnimalType

  @name "Merino Sheep"

  def name, do: @name

  @impl true
  def table, do: "animal_types"

  @impl true
  def depends_on, do: []

  @impl true
  def insert(_) do
    AnimalType.build()
    |> AnimalType.with_name(@name)
    |> AnimalType.with_species("sheep")
    |> AnimalType.with_breed("Merino")
    |> AnimalType.with_typical_weight_kg(Decimal.new("80"))
    |> AnimalType.with_gestation_days(147)
    |> AnimalType.with_life_expectancy_years(12)
    |> AnimalType.insert!()
  end
end
