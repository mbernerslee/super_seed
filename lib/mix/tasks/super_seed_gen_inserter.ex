defmodule Mix.Tasks.SuperSeed.Gen.Inserter do
  @moduledoc """
  `mix super_seed.gen.inserter`
  to generate a new inserter with a placeholder name in the default inserter group

  or

  `mix super_seed.gen.inserter --group <name of inserter group> -- name <name>`
  """

  use Mix.Task
  alias SuperSeed.SideEffectsWrapper
  @shortdoc "Generates a new super_seed inserter file"

  # TODO write this & test it
  # TODO add file_path to config - for where to put new inserters in the file system (default should be lib/super_seed)
  def run(args \\ []) do
    # OptionParser.parse(["--limit", "xyz"], strict: [limit: :integer])
    case OptionParser.parse(args, strict: [group: :string, name: :string]) do
      {parsed, [], []} -> parse_args(parsed)
    end

    :ok
  end

  defp parse_args(args) do
    args
    |> Map.new()
    |> case do
      %{group: _group, name: _name} = args ->
        args

      args ->
        config =
          :super_seed
          |> SideEffectsWrapper.application_get_all_env()

        # TODO handle malformed config
        default_inserter_group =
          Keyword.fetch!(config, :default_inserter_group)

        name =
          config
          |> Keyword.fetch!(:inserter_groups)
          |> Map.fetch!(default_inserter_group)
          |> Map.fetch!(:namespace)

        args
        |> Map.put_new(:group, default_inserter_group)
        |> Map.put_new(:name, Module.concat(name, ChangeMe))
    end
    |> IO.inspect()
  end
end
