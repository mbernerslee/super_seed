defmodule SuperSeed.Support.Schemas.Farm do
  use Ecto.Schema

  schema "farms" do
    field(:name, :string)
    field(:location, :string)
    field(:acreage, :decimal)
    field(:established_date, :date)
    field(:owner_name, :string)
    field(:phone, :string)
    field(:email, :string)

    has_many(:animals, SuperSeed.Support.Schemas.Animal)
    has_many(:feed_inventory, SuperSeed.Support.Schemas.FeedInventory)

    timestamps(type: :utc_datetime)
  end
end
