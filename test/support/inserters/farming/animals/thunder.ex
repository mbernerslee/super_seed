defmodule SuperSeed.Support.Inserters.Farming.Animals.Thunder do
  @behaviour SuperSeed.Inserter

  alias SuperSeed.Support.Builders.Animal
  alias SuperSeed.Support.Inserters.Farming.Farms.SunriseValley
  alias SuperSeed.Support.Inserters.Farming.AnimalTypes.Angus

  @name "Thunder"

  def name, do: @name

  @impl true
  def table, do: "animals"

  @impl true
  def depends_on, do: [{:inserter, SunriseValley}, {:inserter, Angus}]

  @impl true
  def insert(%{SunriseValley => farm, Angus => angus}) do
    Animal.build()
    |> Animal.with_name(@name)
    |> Animal.with_tag_number("BULL-001")
    |> Animal.with_gender("male")
    |> Animal.with_weight_kg(Decimal.new("800"))
    |> Animal.with_farm_id(farm.id)
    |> Animal.with_animal_type_id(angus.id)
    |> Animal.insert!()
  end
end
