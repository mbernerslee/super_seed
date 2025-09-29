defmodule ClientTestApp.SuperSeed.Farming.FeedTypes.Mineral do
  @behaviour SuperSeed.Inserter

  alias ClientTestApp.Support.Builders.FeedType

  @name "Calcium Mineral Supplement"

  def name, do: @name

  @impl true
  def table, do: "feed_types"

  @impl true
  def depends_on, do: []

  @impl true
  def insert(_) do
    FeedType.build()
    |> FeedType.with_name(@name)
    |> FeedType.with_brand("VitaFeed")
    |> FeedType.with_feed_category("mineral")
    |> FeedType.with_protein_percentage(Decimal.new("0.5"))
    |> FeedType.with_supplier("Mineral Co")
    |> FeedType.insert!()
  end
end
