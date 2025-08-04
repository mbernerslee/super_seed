import Config

import_config "test.exs"

config :logger, level: :debug
config :super_seed, side_effects_wrapper_module: SuperSeed.SideEffectsWrapper.Real

config :super_seed, SuperSeed.Repo, database: "super_seed_e2e_test"
