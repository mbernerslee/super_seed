defmodule SuperSeed.Support.Builder do
  @moduledoc """
  Behavior for test data builders.

  Defines the contract that all builders must implement for consistent
  test data generation and database insertion.
  """

  @doc """
  Build a struct with fake data.

  Returns the struct ready for insertion or manipulation.
  """
  @callback build() :: struct()

  @doc """
  Insert a given struct into the database.

  Returns the result of the database insertion.
  """
  @callback insert!(struct()) :: struct()

  @doc """
  Build and insert a struct into the database.

  Convenience function that combines build/0 and insert/1.
  """
  @callback insert!() :: struct()
end
