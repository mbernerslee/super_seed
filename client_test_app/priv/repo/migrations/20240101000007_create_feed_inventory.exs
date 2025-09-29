defmodule ClientTestApp.Repo.Migrations.CreateFeedInventory do
  use Ecto.Migration

  def change do
    create table(:feed_inventory) do
      add :farm_id, references(:farms, on_delete: :delete_all), null: false
      add :feed_type_id, references(:feed_types, on_delete: :restrict), null: false
      add :quantity_kg, :decimal, precision: 10, scale: 2, null: false
      add :purchase_date, :date
      add :expiry_date, :date
      add :cost_per_kg, :decimal, precision: 8, scale: 2
      add :supplier_batch_number, :string
      add :storage_location, :string
      add :notes, :text

      timestamps(type: :utc_datetime)
    end

    create index(:feed_inventory, [:farm_id])
    create index(:feed_inventory, [:feed_type_id])
    create index(:feed_inventory, [:expiry_date])
    create index(:feed_inventory, [:purchase_date])
  end
end