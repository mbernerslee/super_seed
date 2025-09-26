defmodule SuperSeed.Support.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use SuperSeed.Support.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  setup tags do
    SuperSeed.Support.DataCase.setup_sandbox(tags)
    :ok
  end

  @doc """
  Sets up the sandbox based on the test tags.
  """
  def setup_sandbox(tags) do
    # Start Repo once if not already running
    start_repo_once()

    shared = not tags[:async]
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(SuperSeed.Repo, shared: shared)
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
  end

  # started Repo here, such that it is not started automatically by the application.
  defp start_repo_once do
    case Process.whereis(SuperSeed.Repo) do
      nil ->
        {:ok, _pid} = SuperSeed.Repo.start_link()

      pid ->
        {:ok, pid}
    end
  end
end
