# We are not using an elixir Application https://hexdocs.pm/elixir/1.12/Application.html#content, so we don't have a top level supervisor to start the Repo for us, so we do it here.
SuperSeed.Repo.start_link(name: SuperSeed.Repo)
Mimic.copy(SuperSeed.SideEffectsWrapper)
Mimic.copy(SuperSeed.Repo)
ExUnit.start()
