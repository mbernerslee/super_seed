defmodule SuperSeed.Support.Inserters.Farming.Animals.Wilbur do
  @behaviour SuperSeed.Inserter

  alias SuperSeed.Support.Builders.Animal
  alias SuperSeed.Support.Inserters.Farming.Farms.SunriseValley
  alias SuperSeed.Support.Inserters.Farming.AnimalTypes.Duroc

  @name "Wilbur"

  def name, do: @name

  @impl true
  def table, do: "animals"

  @impl true
  def depends_on, do: [{:inserter, SunriseValley}, {:inserter, Duroc}]

  @impl true
  def insert(%{SunriseValley => farm, Duroc => duroc}) do
    Animal.build()
    |> Animal.with_name(@name)
    |> Animal.with_tag_number("PIG-001")
    |> Animal.with_gender("male")
    |> Animal.with_weight_kg(Decimal.new("280"))
    |> Animal.with_farm_id(farm.id)
    |> Animal.with_animal_type_id(duroc.id)
    |> Animal.insert!()
  end
end
