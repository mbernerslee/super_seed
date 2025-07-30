defmodule SuperSeedTest do
  use SuperSeed.Support.DataCase, async: true
  alias SuperSeed.Support.Builders
  alias SuperSeed.Support.Inserters.Farms
  alias SuperSeed.Support.Schemas.Farm

  describe "run/1" do
    test "given an inserter atom, run the inserter" do
      SuperSeed.run(:farms)
      |> IO.inspect()

      name = Farms.name()

      assert [%Farm{name: ^name}] = Repo.all(Farm)
    end

    # TODO deal with config missing / malformed
  end
end
