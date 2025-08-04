defmodule SuperSeed.Support.Inserters.Farming.AnimalTypes.Angus do
  @behaviour SuperSeed.Inserter

  alias SuperSeed.Support.Builders.AnimalType

  @name "Black Angus Cattle"

  def name, do: @name

  @impl true
  def table, do: "animal_types"

  @impl true
  def depends_on, do: []

  @impl true
  def insert(_) do
    AnimalType.build()
    |> AnimalType.with_name(@name)
    |> AnimalType.with_species("cattle")
    |> AnimalType.with_breed("Black Angus")
    |> AnimalType.with_typical_weight_kg(Decimal.new("590"))
    |> AnimalType.with_gestation_days(283)
    |> AnimalType.with_life_expectancy_years(16)
    |> AnimalType.insert!()
  end
end
