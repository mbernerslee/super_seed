defmodule SuperSeed.SetupModuleFinder do
  require Logger

  def find do
    module =
      :super_seed
      |> Application.get_env(:setup, [])
      |> Keyword.get(:module)

    if module do
      Logger.info("[SuperSeed] Using the setup module defined in config: #{inspect(module)}")
      {:ok, module}
    else
      :error
    end
  end
end
