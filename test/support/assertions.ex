defmodule SuperSeed.Support.Assertions do
  import Ecto.Query
  import ExUnit.Assertions
  alias SuperSeed.Repo

  # all strings in assertions below are from test inserters in test/support/inserters/*
  def assert_farm_inserter_group_db_inserts do
    assert Repo.all(from(a in "farms", select: a.name)) == ["Sunrise Valley"]

    assert Repo.all(from(a in "animal_types", order_by: a.name, select: a.name)) == [
             "Black Angus Cattle",
             "Duroc Pig",
             "Holstein Cattle",
             "Merino Sheep"
           ]

    assert Repo.all(
             from(f in "feed_inventory",
               order_by: f.supplier_batch_number,
               select: f.supplier_batch_number
             )
           ) == ["BATCH-001"]

    assert Repo.all(from(a in "animals", order_by: a.name, select: a.name)) == [
             "Bessie",
             "Dolly",
             "Thunder",
             "Wilbur"
           ]

    assert Repo.all(from(f in "feed_types", order_by: f.name, select: f.name)) == [
             "Calcium Mineral Supplement",
             "Corn Grain Mix",
             "High Protein Pellets",
             "Premium Hay"
           ]

    assert Repo.all(from(f in "feeding_schedules", order_by: f.quantity_kg, select: f.quantity_kg)) == [
             Decimal.new("5.00")
           ]

    assert Repo.all(from(h in "health_records", order_by: h.record_type, select: h.record_type)) ==
             ["checkup", "injury", "treatment", "vaccination"]
  end

  def assert_simple_example_inserter_group_db_inserts do
    assert [%{id: farm_id}] = Repo.all(from(f in "farms", select: [:id]))
    assert [%{id: animal_type_id}] = Repo.all(from(f in "animal_types", select: [:id]))

    assert [%{name: "Moolisa", farm_id: ^farm_id, animal_type_id: ^animal_type_id}] =
             Repo.all(from(f in "animals", select: [:name, :farm_id, :animal_type_id]))
  end
end
