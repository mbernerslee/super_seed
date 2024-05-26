import Config

config :super_seed, :setup, [
  [repo: ExampleProject.Repo, app: :example_project, root_namespace: ExampleProject, dir: "example_project"]
]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
