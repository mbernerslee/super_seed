defmodule SuperSeed.Support.Inserter do
  @moduledoc """
  Behaviour for inserter modules that define how to insert test data.

  Each inserter must implement:
  - table/0: Returns the database table name as a string
  - depends_on/0: Returns a list of dependencies as {:table, "name"} or {:inserter, Module}
  - insert/1: Takes a map of resolved dependencies and inserts the record
  """

  @doc """
  Returns the database table name this inserter creates records for.
  """
  @callback table() :: String.t()

  @doc """
  Returns a list of dependencies this inserter needs.
  Dependencies can be:
  - {:table, "table_name"} for table-level dependencies
  - {:inserter, ModuleName} for specific inserter dependencies
  """
  @callback depends_on() :: [
              {:table, String.t()} | {:inserter, module()}
            ]

  @doc """
  Inserts a record using the provided dependency map.
  The map contains resolved dependencies as %{InserterModule => inserted_record}.
  """
  @callback insert(map()) :: any()
end
