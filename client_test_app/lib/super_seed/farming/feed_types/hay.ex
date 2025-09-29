defmodule ClientTestApp.SuperSeed.Farming.FeedTypes.Hay do
  @behaviour SuperSeed.Inserter

  alias ClientTestApp.Support.Builders.FeedType

  @name "Premium Hay"

  def name, do: @name

  @impl true
  def table, do: "feed_types"

  @impl true
  def depends_on, do: []

  @impl true
  def insert(_) do
    FeedType.build()
    |> FeedType.with_name(@name)
    |> FeedType.with_brand("Farm Fresh")
    |> FeedType.with_feed_category("hay")
    |> FeedType.insert!()
  end
end
