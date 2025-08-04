defmodule SuperSeed.Support.Inserters.Farming.FeedTypes.Grain do
  @behaviour SuperSeed.Inserter

  alias SuperSeed.Support.Builders.FeedType

  @name "Corn Grain Mix"

  def name, do: @name

  @impl true
  def table, do: "feed_types"

  @impl true
  def depends_on, do: []

  @impl true
  def insert(_) do
    FeedType.build()
    |> FeedType.with_name(@name)
    |> FeedType.with_brand("AgriCorp")
    |> FeedType.with_feed_category("grain")
    |> FeedType.with_protein_percentage(Decimal.new("14.5"))
    |> FeedType.with_fat_percentage(Decimal.new("3.8"))
    |> FeedType.insert!()
  end
end
