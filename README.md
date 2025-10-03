# SuperSeed

Inserts seed data in parallel very fast.

Define seed data insertion modules and how they depend on each other, then watch them run in parallel as soon as their dependencies have finished inserting, for maximum parallelism & lightening fast seed data insertion.

Have access to the return values of previously run dependent inserters to avoid extra DB lookups that need foreign keys of already-inserted seed data.

## Requirements
- Ecto
- Postgres DB

## Quickstart guide
```elixir
# mix.exs

  defp deps do
    [
      {:super_seed, path: "../"} # TODO put actual hex package in here
    ]
```

Run
`mix deps.get`

```elixir
# config/config.exs

config :super_seed,
  default_inserter_group: :farms,
  inserter_groups: %{
    farms: %{
      namespace: YourApp.SuperSeed,
      repo: YourApp.Repo,
      app: :your_app
    }
  }
```

Then run
```
mix super_seed.gen.inserter
# uses the default inserter group & placeholder module name
```
or
```
mix super_seed.gen.inserter --group farms --name my_new_inserter_name
```


Which generates a file such as the below.
Now be sure to
- set the module name
- set the table
- set the depends_on
- write some seed data inserting code in insert/1

```elixir
# lib/your_app/super_seed/new_inserter.ex

defmodule YourApp.SuperSeed.ChangeMe do
  @behaviour SuperSeed.Inserter
  alias YourApp.Schemas.Farm
  alias YourApp.Repo

  @impl true
  def table, do: "change_me"

  @impl true
  def depends_on do
    # [{:inserter, ModuleDependsOn}, {:table, "some_other_table"}]
    []
  end

  @impl true
  def insert(_) do
    # Write some DB inserting code here...
  end
end

```

Then run
```
mix super_seed
```
or
```
mix super_seed --group farms
```

Then create some more inserters and watch them run as in-parallel possible


## Example

Imagine a farming app.
We have farms, animal_types and animals.

Farms and animal_types can exist in isolation, but animals must have an animal_type and a farm on which they belong.

In the below example, we define 3 inserters.

When we run `mix super_seed`, the farm & animal_type have no dependencies, so their insert/1 functions will run in parallel. When they are done we can insert the sheep, and the results of the previous inserts will be passed as arguements, so we can use the forign keys we need to insert the sheep (farm_id & animal_type_id) in our hand already with no need for extra DB lookups

```elixir

defmodule YourApp.SuperSeed.SunriseValley do
  @behaviour SuperSeed.Inserter
  alias YourApp.Schemas.Farm
  alias YourApp.Repo

  @impl true
  def table, do: "farms"

  @impl true
  def depends_on, do: []

  @impl true
  def insert(_) do
    Repo.insert!(%Farm{name: "Sunrise Valley"})
  end
end

defmodule YourApp.SuperSeed.Sheep do
  @behaviour SuperSeed.Inserter
  alias YourApp.Schemas.AnimalType
  alias YourApp.Repo

  @impl true
  def table, do: "animal_types"

  @impl true
  def depends_on, do: []

  @impl true
  def insert(_) do
    Repo.insert!(%AnimalType{name: "sheep"})
  end
end

defmodule YourApp.SuperSeed.Dolly do
  @behaviour SuperSeed.Inserter
  alias YourApp.Schemas.Animal
  alias YourApp.Schemas.AnimalType
  alias YourApp.SuperSeed.SunriseValley
  alias YourApp.SuperSeed.Sheep
  alias YourApp.Repo

  @impl true
  def table, do: "animals"

  @impl true
  def depends_on, do: [{:inserter, SunriseValley}, {:table, "animal_types"}]

  @impl true
  def insert(%{SunriseValley => farm, Sheep => sheep}) do
    Repo.insert!(%Animal{name: "Dolly", farm_id: farm.id, animal_type_id: sheep.id})
  end
end
```



**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `super_seed` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:super_seed, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/super_seed>.

## Notes
All inserters run within a Repo.transaction/1

## Tips & suggestions
Suggest pairing `mix super_seed` with a script which can delete existing data from the DB without dropping it, such that we can reseed the DB without dropping it DB and killing existing connections. This way we don't necessarily have to restart our running app when we reseed the DB. Such a script could look like:

```bash
#!/usr/bin/env bash

# scripts/truncate_tables.sh

# Check if PGDATABASE environment variable is set
if [ -z "$PGDATABASE" ]; then
  echo "PGDATABASE environment variable is not set"
  exit 1
else
  echo "using PGDATABASE=$PGDATABASE"
fi

TRUNCATE_CMD=$(psql -t -c "
  SELECT 'TRUNCATE TABLE ' || string_agg(tablename, ', ') || ';'
  FROM pg_tables WHERE schemaname = 'public';
")

psql -c "$TRUNCATE_CMD"
```

Then you can have a custom mix alias to reseed the DB (but not run migrations, nor drop existing DB connections), or fully reset the DB (drop it, rerun migrations & reseed) as you wish
```elixir
  defp aliases do
    [
      "ecto.clean": ["ecto.drop", "ecto.create", "ecto.migrate"],
      "ecto.trunc": ["cmd ./scripts/truncate_tables.sh"],
      "ecto.reseed": ["ecto.trunc", "super_seed"],
      "ecto.reset": ["ecto.clean", "super_seed"]
    ]
  end

```

Obviously you'll need safeguards to make sure you can't run such things in prod!

## Trade-offs & Failure
In the trade-off of "insertion speed" vs "DB consistency in case of failure", we prioritises speed.

If an inserter fails, then the DB will be left in an unknown half-seeded state.
It would be complex to rollback every inserter which ran to completion if one later down the road failed, which at the time of writing super_seed does not do.

This is considered a good choice in the trade-off since this is for seed data and should never be used on prod. In local dev or staging environments we should diagnose the bug that caused an inserter to fail and reset the DB and try again.
