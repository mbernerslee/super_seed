import Config

config :super_seed, side_effects_wrapper_module: SuperSeed.SideEffectsWrapper.Real

import_config "#{config_env()}.exs"
