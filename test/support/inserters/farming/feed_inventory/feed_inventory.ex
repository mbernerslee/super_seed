defmodule SuperSeed.Support.Inserters.Farming.FeedInventory do
  @behaviour SuperSeed.Inserter

  alias SuperSeed.Support.Builders.FeedInventory
  alias SuperSeed.Support.Inserters.Farming.Farms.SunriseValley
  alias SuperSeed.Support.Inserters.Farming.FeedTypes.Hay

  @name "Hay Inventory Batch 001"

  def name, do: @name

  @impl true
  def table, do: "feed_inventory"

  @impl true
  def depends_on, do: [{:inserter, SunriseValley}, {:inserter, Hay}]

  @impl true
  def insert(%{SunriseValley => farm, Hay => feed_type}) do
    FeedInventory.build()
    |> FeedInventory.with_supplier_batch_number("BATCH-001")
    |> FeedInventory.with_quantity_kg(Decimal.new("500.0"))
    |> FeedInventory.with_storage_location("Barn 1")
    |> FeedInventory.with_farm_id(farm.id)
    |> FeedInventory.with_feed_type_id(feed_type.id)
    |> FeedInventory.insert!()
  end
end