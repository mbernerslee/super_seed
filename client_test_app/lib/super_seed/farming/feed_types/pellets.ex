defmodule ClientTestApp.SuperSeed.Farming.FeedTypes.Pellets do
  @behaviour SuperSeed.Inserter

  alias ClientTestApp.Support.Builders.FeedType

  @name "High Protein Pellets"

  def name, do: @name

  @impl true
  def table, do: "feed_types"

  @impl true
  def depends_on, do: []

  @impl true
  def insert(_) do
    FeedType.build()
    |> FeedType.with_name(@name)
    |> FeedType.with_brand("NutriMax")
    |> FeedType.with_feed_category("pellet")
    |> FeedType.with_protein_percentage(Decimal.new("22.0"))
    |> FeedType.with_fat_percentage(Decimal.new("4.2"))
    |> FeedType.insert!()
  end
end
