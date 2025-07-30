defmodule SuperSeed.Repo.Migrations.CreateFarms do
  use Ecto.Migration

  def change do
    create table(:farms) do
      add :name, :string, null: false
      add :location, :string
      add :acreage, :decimal, precision: 10, scale: 2
      add :established_date, :date
      add :owner_name, :string
      add :phone, :string
      add :email, :string

      timestamps(type: :utc_datetime)
    end

    create index(:farms, [:name])
    create index(:farms, [:location])
  end
end