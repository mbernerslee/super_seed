defmodule ClientTestApp.Schemas.HealthRecord do
  use Ecto.Schema

  schema "health_records" do
    field(:record_date, :date)
    field(:record_type, :string)
    field(:description, :string)
    field(:veterinarian, :string)
    field(:treatment, :string)
    field(:medication, :string)
    field(:dosage, :string)
    field(:cost, :decimal)
    field(:follow_up_date, :date)
    field(:notes, :string)

    belongs_to(:animal, ClientTestApp.Schemas.Animal)

    timestamps(type: :utc_datetime)
  end
end
