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
               %{A => :pending, B => :pending, C => :pending}
             ) == MapSet.new([A, B, C])
    end

    test "when all dependencies are finished, they can run" do
      assert WhichInsertersCanRun.determine(
               %{A => [B], B => [C], C => [], D => []},
               %{A => :pending, B => :pending, C => :finished, D => :finished}
             ) == MapSet.new([B])
    end

    test "when some dependencies are not finished, they cannot run" do
      assert WhichInsertersCanRun.determine(
               %{A => [B, C, D, E], B => [C, D], D => [E]},
               %{A => :pending, B => :pending, C => :finished, D => :pending, E => :finished}
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
                 AnimalTypes.Angus => :pending,
                 AnimalTypes.Duroc => :pending,
                 AnimalTypes.Holstein => :pending,
                 AnimalTypes.Merino => :pending,
                 Farms.SunriseValley => :pending,
                 FeedTypes.Grain => :pending,
                 FeedTypes.Hay => :pending,
                 FeedTypes.Mineral => :pending,
                 FeedTypes.Pellets => :pending,
                 HealthRecords.Checkup => :pending,
                 HealthRecords.Treatment => :pending,
                 Animals.Bessie => :pending,
                 Animals.Dolly => :pending,
                 Animals.Thunder => :pending,
                 Animals.Wilbur => :pending,
                 FeedingSchedules => :pending,
                 FeedInventory => :pending,
                 HealthRecords.Injury => :pending,
                 HealthRecords.Vaccination => :pending
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
                 A => :pending,
                 B => :pending,
                 C => :pending,
                 D => :running,
                 E => :finished,
                 F => :finished
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
                 AnimalTypes.Angus => :finished,
                 AnimalTypes.Duroc => :finished,
                 AnimalTypes.Holstein => :finished,
                 AnimalTypes.Merino => :finished,
                 Farms.SunriseValley => :finished,
                 FeedTypes.Grain => :finished,
                 FeedTypes.Hay => :finished,
                 FeedTypes.Mineral => :finished,
                 FeedTypes.Pellets => :finished,
                 Animals.Bessie => :finished,
                 HealthRecords.Checkup => :running,
                 HealthRecords.Treatment => :running,
                 Animals.Dolly => :pending,
                 Animals.Thunder => :pending,
                 Animals.Wilbur => :pending,
                 FeedingSchedules => :pending,
                 FeedInventory => :pending,
                 HealthRecords.Injury => :pending,
                 HealthRecords.Vaccination => :pending
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
