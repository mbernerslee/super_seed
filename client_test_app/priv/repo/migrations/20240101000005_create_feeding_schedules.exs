defmodule ClientTestApp.Repo.Migrations.CreateFeedingSchedules do
  use Ecto.Migration

  def change do
    create table(:feeding_schedules) do
      add :animal_id, references(:animals, on_delete: :delete_all), null: false
      add :feed_type_id, references(:feed_types, on_delete: :restrict), null: false
      add :quantity_kg, :decimal, precision: 8, scale: 2, null: false
      add :feeding_time, :time, null: false
      add :frequency_per_day, :integer, default: 1
      add :start_date, :date, null: false
      add :end_date, :date
      add :notes, :text

      timestamps(type: :utc_datetime)
    end

    create index(:feeding_schedules, [:animal_id])
    create index(:feeding_schedules, [:feed_type_id])
    create index(:feeding_schedules, [:start_date])
    create index(:feeding_schedules, [:feeding_time])
  end
end