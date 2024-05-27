defmodule SuperSeed.ConfigReader do
  alias SuperSeed.Checks

  @setup_keys [:repo, :app, :root_namespace, :name]

  # TODO parse root_namespace, make sure its a real module?
  def read(args \\ []) do
    options =
      args
      |> OptionParser.parse(strict: [name: :string])
      |> validate_options()

    :super_seed
    |> Checks.application_get_env(:setup)
    |> parse_setup(options)
  end

  defp validate_options({options, [], []}) do
    Map.new(options)
  end

  defp validate_options(_) do
    raise """
    You provided some args I don't understand.
    Args I do understand:

    --name name
    """
  end

  defp parse_setup([setup], _options) do
    build_setup_from_config(setup)
  end

  defp parse_setup([_ | _] = setups, options) do
    requested_name = Map.get(options, :name)

    setup =
      case requested_name do
        nil ->
          raise """
          You have more than one named setup configured, so you must tell me which one you're using.
          Please specify with the argument

          --name name
          """

        name ->
          Enum.find(setups, fn setup -> Keyword.get(setup, :name) == name end)
      end

    if setup == nil do
      raise """
      You told me to find a --name in config called "#{requested_name}", but I couldn't find that in your config
      """
    end

    build_setup_from_config(setup)
  end

  defp parse_setup(_, _) do
    raise """
    I tried to read the :setup configuration for :super_seed, but it I didn't find any.
    Maybe you skipped the step in the README about adding some config to config/config.exs?
    """
  end

  defp build_setup_from_config(setup_from_config) do
    Enum.reduce(@setup_keys, %{}, fn key, acc ->
      case Keyword.get(setup_from_config, key) do
        nil ->
          raise """
          I tried to read the :setup configuration for :super_seed, but it looks like I've been misconfigured.

          I'm missing the key: #{inspect(key)}

          Maybe reread the README bit about adding some config?
          """

        value ->
          Map.put(acc, key, value)
      end
    end)
  end
end
