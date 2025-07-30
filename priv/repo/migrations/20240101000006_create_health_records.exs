defmodule SuperSeed.Repo.Migrations.CreateHealthRecords do
  use Ecto.Migration

  def change do
    create table(:health_records) do
      add :animal_id, references(:animals, on_delete: :delete_all), null: false
      add :record_date, :date, null: false
      add :record_type, :string, null: false
      add :description, :text, null: false
      add :veterinarian, :string
      add :treatment, :string
      add :medication, :string
      add :dosage, :string
      add :cost, :decimal, precision: 8, scale: 2
      add :follow_up_date, :date
      add :notes, :text

      timestamps(type: :utc_datetime)
    end

    create index(:health_records, [:animal_id])
    create index(:health_records, [:record_date])
    create index(:health_records, [:record_type])
    create index(:health_records, [:follow_up_date])
  end
end