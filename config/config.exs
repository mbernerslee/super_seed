import Config

config :super_seed, :setup, [
  [name: "super_seed", repo: SuperSeed.ExampleRepo, app: :super_seed, root_namespace: SuperSeed]
]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
