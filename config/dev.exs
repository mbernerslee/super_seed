import Config

config :logger, level: :warning

config :super_seed,
  default_inserter_group: :farms,
  inserter_groups: %{
    farms: %{
      namespace: SuperSeed.Support.Inserters.Farming,
      repo: SuperSeed.Repo,
      app: :super_seed
    },
    simple_example: %{
      namespace: SuperSeed.Support.Inserters.SimpleExample,
      repo: SuperSeed.Repo,
      app: :super_seed
    }
  }

case System.get_env("SUPER_SEED_USE_REAL_SIDE_EFFECTS_WRAPPER_MODULE", "true") do
  "false" -> config :super_seed, side_effects_wrapper_module: SuperSeed.SideEffectsWrapper.Fake
  "true" -> config :super_seed, side_effects_wrapper_module: SuperSeed.SideEffectsWrapper.Real
end
