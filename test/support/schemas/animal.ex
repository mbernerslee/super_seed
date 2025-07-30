defmodule SuperSeed.Support.Schemas.Animal do
  use Ecto.Schema

  schema "animals" do
    field :name, :string
    field :tag_number, :string
    field :birth_date, :date
    field :gender, :string
    field :weight_kg, :decimal
    field :health_status, :string, default: "healthy"
    field :notes, :string

    belongs_to :farm, SuperSeed.Support.Schemas.Farm
    belongs_to :animal_type, SuperSeed.Support.Schemas.AnimalType
    belongs_to :mother, SuperSeed.Support.Schemas.Animal
    belongs_to :father, SuperSeed.Support.Schemas.Animal

    has_many :children_as_mother, SuperSeed.Support.Schemas.Animal, foreign_key: :mother_id
    has_many :children_as_father, SuperSeed.Support.Schemas.Animal, foreign_key: :father_id
    has_many :health_records, SuperSeed.Support.Schemas.HealthRecord
    has_many :feeding_schedules, SuperSeed.Support.Schemas.FeedingSchedule

    timestamps type: :utc_datetime
  end
end