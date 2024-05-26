import Config

config :super_seed, :setup, [
  [repo: SuperSeed.ExampleRepo, app: :super_seed, root_namespace: SuperSeed, dir: "super_seed"]
]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
