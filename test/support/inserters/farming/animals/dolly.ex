defmodule SuperSeed.Support.Inserters.Farming.Animals.Dolly do
  @behaviour SuperSeed.Inserter

  alias SuperSeed.Support.Builders.Animal
  alias SuperSeed.Support.Inserters.Farming.Farms.SunriseValley
  alias SuperSeed.Support.Inserters.Farming.AnimalTypes.Merino

  @name "Dolly"

  def name, do: @name

  @impl true
  def table, do: "animals"

  @impl true
  def depends_on, do: [{:inserter, SunriseValley}, {:inserter, Merino}]

  @impl true
  def insert(%{SunriseValley => farm, Merino => merino}) do
    Animal.build()
    |> Animal.with_name(@name)
    |> Animal.with_tag_number("SHEEP-001")
    |> Animal.with_gender("female")
    |> Animal.with_weight_kg(Decimal.new("75"))
    |> Animal.with_farm_id(farm.id)
    |> Animal.with_animal_type_id(merino.id)
    |> Animal.insert!()
  end
end
