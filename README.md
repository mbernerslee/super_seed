# SuperSeed

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

## Test DB - Database Schema Relationships (AI generated diagram)

  ┌─────────────────┐
  │     FARMS       │
  │ ┌─────────────┐ │     ┌──────────────────┐
  │ │ id (PK)     │ │     │   ANIMAL_TYPES   │
  │ │ name        │ │     │ ┌──────────────┐ │
  │ │ location    │ │     │ │ id (PK)      │ │
  │ │ acreage     │ │     │ │ name         │ │
  │ │ owner_name  │ │     │ │ species      │ │
  │ │ ...         │ │     │ │ breed        │ │
  │ └─────────────┘ │     │ │ ...          │ │
  └─────────────────┘     │ └──────────────┘ │
           │              └──────────────────┘
           │                        │
           │                        │
           ▼                        ▼
  ┌─────────────────────────────────────────────┐
  │                ANIMALS                      │
  │ ┌─────────────────────────────────────────┐ │
  │ │ id (PK)                                 │ │
  │ │ farm_id (FK → farms.id)                 │ │
  │ │ animal_type_id (FK → animal_types.id)   │ │
  │ │ mother_id (FK → animals.id) [SELF]      │ │
  │ │ father_id (FK → animals.id) [SELF]      │ │
  │ │ name, tag_number, gender, ...           │ │
  │ └─────────────────────────────────────────┘ │
  └─────────────────────────────────────────────┘
           │
           │
           ├────────────────────────────────────┐
           │                                    │
           ▼                                    ▼
  ┌─────────────────┐                ┌─────────────────┐
  │ HEALTH_RECORDS  │                │ FEEDING_SCHED.  │
  │ ┌─────────────┐ │                │ ┌─────────────┐ │
  │ │ id (PK)     │ │                │ │ id (PK)     │ │
  │ │ animal_id   │ │◄───────────────┤ │ animal_id   │ │
  │ │ record_date │ │                │ │ feed_type_id│ │◄─┐
  │ │ record_type │ │                │ │ quantity_kg │ │  │
  │ │ treatment   │ │                │ │ ...         │ │  │
  │ │ ...         │ │                │ └─────────────┘ │  │
  │ └─────────────┘ │                └─────────────────┘  │
  └─────────────────┘                                     │
                                                          │
  ┌──────────────────┐                                    │
  │   FEED_TYPES     │                                    │
  │ ┌──────────────┐ │                                    │
  │ │ id (PK)      │ │◄───────────────────────────────────┘
  │ │ name         │ │
  │ │ brand        │ │
  │ │ category     │ │
  │ │ protein_%    │ │
  │ │ cost_per_kg  │ │
  │ │ ...          │ │
  │ └──────────────┘ │
  └──────────────────┘
           ▲
           │
           │
  ┌─────────────────┐
  │ FEED_INVENTORY  │
  │ ┌─────────────┐ │
  │ │ id (PK)     │ │
  │ │ farm_id     │ │◄─────────────────┐
  │ │ feed_type_id│ │                  │
  │ │ quantity_kg │ │                  │
  │ │ expiry_date │ │                  │
  │ │ ...         │ │                  │
  │ └─────────────┘ │                  │
  └─────────────────┘                  │
                                       │
                      ─────────────────┘


