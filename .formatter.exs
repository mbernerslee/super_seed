# Used by "mix format"
env_uses_db? = Application.compile_env(:super_seed, SuperSeed.Repo) != nil

import_deps =
  if env_uses_db? do
    [:ecto, :ecto_sql]
  else
    []
  end

[
  import_deps: import_deps,
  subdirectories: ["priv/*/migrations"],
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}", "priv/*/seeds.exs"],
  line_length: 120
]
