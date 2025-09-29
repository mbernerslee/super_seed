defmodule ClientTestApp.SuperSeed.Farming.Animals.Bessie do
  @behaviour SuperSeed.Inserter

  alias ClientTestApp.Support.Builders.Animal
  alias ClientTestApp.SuperSeed.Farming.AnimalTypes.Holstein
  alias ClientTestApp.SuperSeed.Farming.Farms.SunriseValley

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
