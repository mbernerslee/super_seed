defmodule SuperSeed.Repo.Migrations.CreateFeedTypes do
  use Ecto.Migration

  def change do
    create table(:feed_types) do
      add :name, :string, null: false
      add :brand, :string
      add :feed_category, :string, null: false
      add :protein_percentage, :decimal, precision: 5, scale: 2
      add :fat_percentage, :decimal, precision: 5, scale: 2
      add :fiber_percentage, :decimal, precision: 5, scale: 2
      add :calories_per_kg, :integer
      add :cost_per_kg, :decimal, precision: 8, scale: 2
      add :supplier, :string
      add :description, :text

      timestamps(type: :utc_datetime)
    end

    create index(:feed_types, [:name])
    create index(:feed_types, [:feed_category])
    create index(:feed_types, [:supplier])
  end
end