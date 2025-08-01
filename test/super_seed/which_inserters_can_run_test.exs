defmodule SuperSeed.WhichInsertersCanRunTest do
  use ExUnit.Case, async: true

  alias SuperSeed.WhichInsertersCanRun
  alias SuperSeed.Support.Inserters.Farming.Animals
  alias SuperSeed.Support.Inserters.Farming.AnimalTypes
  alias SuperSeed.Support.Inserters.Farming.Farms
  alias SuperSeed.Support.Inserters.Farming.FeedInventory
  alias SuperSeed.Support.Inserters.Farming.FeedingSchedules
  alias SuperSeed.Support.Inserters.Farming.FeedTypes
  alias SuperSeed.Support.Inserters.Farming.HealthRecords

  describe "which/2" do
    test "when depending on nothing, it can run" do
      assert WhichInsertersCanRun.determine(%{}, %{}) == MapSet.new([])

      assert WhichInsertersCanRun.determine(
               %{A => [], B => [], C => []},
               %{A => %{status: :pending}, B => %{status: :pending}, C => %{status: :pending}}
             ) == MapSet.new([A, B, C])
    end

    test "when all dependencies are finished, they can run" do
      assert WhichInsertersCanRun.determine(
               %{A => [B], B => [C], C => [], D => []},
               %{
                 A => %{status: :pending},
                 B => %{status: :pending},
                 C => %{status: :finished},
                 D => %{status: :finished}
               }
             ) == MapSet.new([B])
    end

    test "when some dependencies are not finished, they cannot run" do
      assert WhichInsertersCanRun.determine(
               %{A => [B, C, D, E], B => [C, D], D => [E]},
               %{
                 A => %{status: :pending},
                 B => %{status: :pending},
                 C => %{status: :finished},
                 D => %{status: :pending},
                 E => %{status: :finished}
               }
             ) == MapSet.new([D])

      assert WhichInsertersCanRun.determine(
               %{
                 AnimalTypes.Angus => [],
                 AnimalTypes.Duroc => [],
                 AnimalTypes.Holstein => [],
                 AnimalTypes.Merino => [],
                 Farms.SunriseValley => [],
                 FeedTypes.Grain => [],
                 FeedTypes.Hay => [],
                 FeedTypes.Mineral => [],
                 FeedTypes.Pellets => [],
                 HealthRecords.Checkup => [Animals.Bessie],
                 HealthRecords.Treatment => [Animals.Thunder],
                 Animals.Bessie => [Farms.SunriseValley, AnimalTypes.Holstein],
                 Animals.Dolly => [Farms.SunriseValley, AnimalTypes.Merino],
                 Animals.Thunder => [Farms.SunriseValley, AnimalTypes.Angus],
                 Animals.Wilbur => [Farms.SunriseValley, AnimalTypes.Duroc],
                 FeedingSchedules => [Animals.Bessie, FeedTypes.Hay],
                 FeedInventory => [Farms.SunriseValley, FeedTypes.Hay],
                 HealthRecords.Injury => [
                   Animals.Wilbur,
                   Animals.Thunder,
                   Animals.Dolly,
                   Animals.Bessie
                 ],
                 HealthRecords.Vaccination => [
                   Animals.Wilbur,
                   Animals.Thunder,
                   Animals.Dolly,
                   Animals.Bessie
                 ]
               },
               %{
                 AnimalTypes.Angus => %{status: :pending},
                 AnimalTypes.Duroc => %{status: :pending},
                 AnimalTypes.Holstein => %{status: :pending},
                 AnimalTypes.Merino => %{status: :pending},
                 Farms.SunriseValley => %{status: :pending},
                 FeedTypes.Grain => %{status: :pending},
                 FeedTypes.Hay => %{status: :pending},
                 FeedTypes.Mineral => %{status: :pending},
                 FeedTypes.Pellets => %{status: :pending},
                 HealthRecords.Checkup => %{status: :pending},
                 HealthRecords.Treatment => %{status: :pending},
                 Animals.Bessie => %{status: :pending},
                 Animals.Dolly => %{status: :pending},
                 Animals.Thunder => %{status: :pending},
                 Animals.Wilbur => %{status: :pending},
                 FeedingSchedules => %{status: :pending},
                 FeedInventory => %{status: :pending},
                 HealthRecords.Injury => %{status: :pending},
                 HealthRecords.Vaccination => %{status: :pending}
               }
             ) ==
               MapSet.new([
                 AnimalTypes.Angus,
                 AnimalTypes.Duroc,
                 AnimalTypes.Holstein,
                 AnimalTypes.Merino,
                 Farms.SunriseValley,
                 FeedTypes.Grain,
                 FeedTypes.Hay,
                 FeedTypes.Mineral,
                 FeedTypes.Pellets
               ])
    end

    test "if a dependency is running, then its dependents cannot" do
      assert WhichInsertersCanRun.determine(
               %{A => [B, C], B => [D, E], C => [F], D => [E], E => [F]},
               %{
                 A => %{status: :pending},
                 B => %{status: :pending},
                 C => %{status: :pending},
                 D => %{status: :running},
                 E => %{status: :finished},
                 F => %{status: :finished}
               }
             ) == MapSet.new([C])
    end

    test "complex mid-way through state" do
      assert WhichInsertersCanRun.determine(
               %{
                 AnimalTypes.Angus => [],
                 AnimalTypes.Duroc => [],
                 AnimalTypes.Holstein => [],
                 AnimalTypes.Merino => [],
                 Farms.SunriseValley => [],
                 FeedTypes.Grain => [],
                 FeedTypes.Hay => [],
                 FeedTypes.Mineral => [],
                 FeedTypes.Pellets => [],
                 HealthRecords.Checkup => [Animals.Bessie],
                 HealthRecords.Treatment => [Animals.Thunder],
                 Animals.Bessie => [Farms.SunriseValley, AnimalTypes.Holstein],
                 Animals.Dolly => [Farms.SunriseValley, AnimalTypes.Merino],
                 Animals.Thunder => [Farms.SunriseValley, AnimalTypes.Angus],
                 Animals.Wilbur => [Farms.SunriseValley, AnimalTypes.Duroc],
                 FeedingSchedules => [Animals.Bessie, FeedTypes.Hay],
                 FeedInventory => [Farms.SunriseValley, FeedTypes.Hay],
                 HealthRecords.Injury => [
                   Animals.Wilbur,
                   Animals.Thunder,
                   Animals.Dolly,
                   Animals.Bessie
                 ],
                 HealthRecords.Vaccination => [
                   Animals.Wilbur,
                   Animals.Thunder,
                   Animals.Dolly,
                   Animals.Bessie
                 ]
               },
               %{
                 AnimalTypes.Angus => %{status: :finished},
                 AnimalTypes.Duroc => %{status: :finished},
                 AnimalTypes.Holstein => %{status: :finished},
                 AnimalTypes.Merino => %{status: :finished},
                 Farms.SunriseValley => %{status: :finished},
                 FeedTypes.Grain => %{status: :finished},
                 FeedTypes.Hay => %{status: :finished},
                 FeedTypes.Mineral => %{status: :finished},
                 FeedTypes.Pellets => %{status: :finished},
                 Animals.Bessie => %{status: :finished},
                 HealthRecords.Checkup => %{status: :running},
                 HealthRecords.Treatment => %{status: :running},
                 Animals.Dolly => %{status: :pending},
                 Animals.Thunder => %{status: :pending},
                 Animals.Wilbur => %{status: :pending},
                 FeedingSchedules => %{status: :pending},
                 FeedInventory => %{status: :pending},
                 HealthRecords.Injury => %{status: :pending},
                 HealthRecords.Vaccination => %{status: :pending}
               }
             ) ==
               MapSet.new([
                 Animals.Dolly,
                 Animals.Thunder,
                 Animals.Wilbur,
                 FeedingSchedules,
                 FeedInventory
               ])
    end
  end
end
