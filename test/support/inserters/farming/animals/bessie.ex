defmodule SuperSeed.Support.Inserters.Farming.Animals.Bessie do
  @behaviour SuperSeed.Inserter

  alias SuperSeed.Support.Builders.Animal
  alias SuperSeed.Support.Inserters.Farming.AnimalTypes.Holstein
  alias SuperSeed.Support.Inserters.Farming.Farms.SunriseValley

  @name "Bessie"

  def name, do: @name

  @impl true
  def table, do: "animals"

  @impl true
  def depends_on, do: [{:table, "farms"}, {:inserter, Holstein}]

  @impl true
  def insert(%{Holstein => holstein, SunriseValley => farm}) do
    Animal.build()
    |> Animal.with_name(@name)
    |> Animal.with_tag_number("COW-001")
    |> Animal.with_gender("female")
    |> Animal.with_farm_id(farm.id)
    |> Animal.with_animal_type_id(holstein.id)
    |> Animal.insert!()
  end
end