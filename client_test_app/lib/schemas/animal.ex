defmodule ClientTestApp.Schemas.Animal do
  use Ecto.Schema

  schema "animals" do
    field(:name, :string)
    field(:tag_number, :string)
    field(:birth_date, :date)
    field(:gender, :string)
    field(:weight_kg, :decimal)
    field(:health_status, :string, default: "healthy")
    field(:notes, :string)

    belongs_to(:farm, ClientTestApp.Schemas.Farm)
    belongs_to(:animal_type, ClientTestApp.Schemas.AnimalType)
    belongs_to(:mother, ClientTestApp.Schemas.Animal)
    belongs_to(:father, ClientTestApp.Schemas.Animal)

    has_many(:children_as_mother, ClientTestApp.Schemas.Animal, foreign_key: :mother_id)
    has_many(:children_as_father, ClientTestApp.Schemas.Animal, foreign_key: :father_id)
    has_many(:health_records, ClientTestApp.Schemas.HealthRecord)
    has_many(:feeding_schedules, ClientTestApp.Schemas.FeedingSchedule)

    timestamps(type: :utc_datetime)
  end
end
