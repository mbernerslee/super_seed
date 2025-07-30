defmodule SuperSeed.Support.Inserters.Farms do
  alias SuperSeed.Support.Builders.Farm

  @name "Sunrise Valley"

  def name, do: @name

  def table, do: "farms"
  def depends_on, do: []

  def insert(_) do
    Farm.build()
    |> Farm.with_name(@name)
    |> Farm.insert!()

    # |> Builders.Farm.with_location("Greenfield, Iowa")
    # |> Builders.Farm.with_acreage(Decimal.new("247.5"))
    # |> Builders.Farm.with_established_date(~D[1952-06-15])
    # |> Builders.Farm.with_owner_name("Robert Thompson")
    # |> Builders.Farm.with_phone("+1-555-0123")
    # |> Builders.Farm.with_email("robert@sunrisevalley.farm")
    # |> Builders.Farm.insert!()
  end
end
