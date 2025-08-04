defmodule SuperSeed.Support.Schemas.AnimalType do
  use Ecto.Schema

  schema "animal_types" do
    field :name, :string
    field :species, :string
    field :breed, :string
    field :typical_weight_kg, :decimal
    field :gestation_days, :integer
    field :life_expectancy_years, :integer
    field :description, :string

    has_many :animals, SuperSeed.Support.Schemas.Animal

    timestamps type: :utc_datetime
  end
end
