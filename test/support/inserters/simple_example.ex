defmodule SuperSeed.Support.Inserters.SimpleExample.FunkyFarm do
  @behaviour SuperSeed.Inserter
  alias SuperSeed.Support.Builders.Farm

  def table, do: "farms"
  def depends_on, do: []

  def insert(_) do
    Farm.insert!()
  end
end

defmodule SuperSeed.Support.Inserters.SimpleExample.Holstein do
  @behaviour SuperSeed.Inserter
  alias SuperSeed.Support.Inserters.SimpleExample.FunkyFarm
  alias SuperSeed.Support.Builders.AnimalType

  def table, do: "animal_types"
  def depends_on, do: []

  def insert(_) do
    AnimalType.insert!()
  end
end

defmodule SuperSeed.Support.Inserters.SimpleExample.Moolisa do
  @behaviour SuperSeed.Inserter

  alias SuperSeed.Support.Builders.Animal
  alias SuperSeed.Support.Inserters.SimpleExample.Holstein
  alias SuperSeed.Support.Inserters.SimpleExample.FunkyFarm

  @impl true
  def table, do: "animals"

  @impl true
  def depends_on, do: [{:table, "farms"}, {:inserter, Holstein}]

  @impl true
  def insert(%{Holstein => holstein, FunkyFarm => farm}) do
    Animal.build()
    |> Animal.with_name("Moolisa")
    |> Animal.with_farm_id(farm.id)
    |> Animal.with_animal_type_id(holstein.id)
    |> Animal.insert!()
  end
end
