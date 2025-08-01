defmodule SuperSeed.Support.Inserters.Farming.Farms.SunriseValley do
  @behaviour SuperSeed.Inserter

  alias SuperSeed.Support.Builders.Farm

  @name "Sunrise Valley"

  def name, do: @name

  @impl true
  def table, do: "farms"

  @impl true
  def depends_on, do: []

  @impl true
  def insert(_) do
    Farm.build()
    |> Farm.with_name(@name)
    |> Farm.insert!()
  end
end