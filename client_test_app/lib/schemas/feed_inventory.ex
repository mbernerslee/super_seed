defmodule ClientTestApp.Schemas.FeedInventory do
  use Ecto.Schema

  schema "feed_inventory" do
    field(:quantity_kg, :decimal)
    field(:purchase_date, :date)
    field(:expiry_date, :date)
    field(:cost_per_kg, :decimal)
    field(:supplier_batch_number, :string)
    field(:storage_location, :string)
    field(:notes, :string)

    belongs_to(:farm, ClientTestApp.Schemas.Farm)
    belongs_to(:feed_type, ClientTestApp.Schemas.FeedType)

    timestamps(type: :utc_datetime)
  end
end
