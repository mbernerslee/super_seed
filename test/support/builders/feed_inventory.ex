defmodule SuperSeed.Support.Builders.FeedInventory do
  @behaviour SuperSeed.Support.Builder

  alias SuperSeed.Repo
  alias SuperSeed.Support.Schemas.FeedInventory

  @impl true
  def build do
    purchase_date = Faker.Date.between(~D[2024-01-01], ~D[2024-06-30])

    %FeedInventory{
      quantity_kg: Decimal.new(:rand.uniform(1000) + 100),
      purchase_date: purchase_date,
      expiry_date: Date.add(purchase_date, :rand.uniform(365) + 90),
      cost_per_kg: Decimal.new(:rand.uniform(50) + 10),
      supplier_batch_number: "BATCH-#{:rand.uniform(9999)}",
      storage_location: Enum.random(["Warehouse A", "Barn 1", "Silo 2", "Storage Room B"]),
      notes: Faker.Lorem.sentence()
    }
  end

  @impl true
  def insert!(feed_inventory) do
    Repo.insert!(feed_inventory)
  end

  @impl true
  def insert!, do: insert!(build())

  def with_quantity_kg(feed_inventory, quantity), do: %{feed_inventory | quantity_kg: quantity}
  def with_purchase_date(feed_inventory, date), do: %{feed_inventory | purchase_date: date}
  def with_expiry_date(feed_inventory, date), do: %{feed_inventory | expiry_date: date}
  def with_cost_per_kg(feed_inventory, cost), do: %{feed_inventory | cost_per_kg: cost}
  def with_supplier_batch_number(feed_inventory, batch), do: %{feed_inventory | supplier_batch_number: batch}
  def with_storage_location(feed_inventory, location), do: %{feed_inventory | storage_location: location}
  def with_notes(feed_inventory, notes), do: %{feed_inventory | notes: notes}
  def with_farm_id(feed_inventory, farm_id), do: %{feed_inventory | farm_id: farm_id}
  def with_feed_type_id(feed_inventory, feed_type_id), do: %{feed_inventory | feed_type_id: feed_type_id}
end
