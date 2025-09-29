defmodule ClientTestApp.Schemas.Farm do
  use Ecto.Schema

  schema "farms" do
    field(:name, :string)
    field(:location, :string)
    field(:acreage, :decimal)
    field(:established_date, :date)
    field(:owner_name, :string)
    field(:phone, :string)
    field(:email, :string)

    has_many(:animals, ClientTestApp.Schemas.Animal)
    has_many(:feed_inventory, ClientTestApp.Schemas.FeedInventory)

    timestamps(type: :utc_datetime)
  end
end
