defmodule ClientTestApp.Repo.Migrations.CreateAnimals do
  use Ecto.Migration

  def change do
    create table(:animals) do
      add :name, :string
      add :tag_number, :string, null: false
      add :birth_date, :date
      add :gender, :string, null: false
      add :weight_kg, :decimal, precision: 8, scale: 2
      add :health_status, :string, default: "healthy"
      add :notes, :text
      
      add :farm_id, references(:farms, on_delete: :delete_all), null: false
      add :animal_type_id, references(:animal_types, on_delete: :restrict), null: false
      add :mother_id, references(:animals, on_delete: :nilify_all)
      add :father_id, references(:animals, on_delete: :nilify_all)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:animals, [:farm_id, :tag_number])
    create index(:animals, [:farm_id])
    create index(:animals, [:animal_type_id])
    create index(:animals, [:birth_date])
    create index(:animals, [:health_status])
  end
end