defmodule SuperSeed.Repo.Migrations.CreateAnimalTypes do
  use Ecto.Migration

  def change do
    create table(:animal_types) do
      add :name, :string, null: false
      add :species, :string, null: false
      add :breed, :string
      add :typical_weight_kg, :decimal, precision: 8, scale: 2
      add :gestation_days, :integer
      add :life_expectancy_years, :integer
      add :description, :text

      timestamps(type: :utc_datetime)
    end

    create unique_index(:animal_types, [:species, :breed])
  end
end