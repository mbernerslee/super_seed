defmodule SuperSeed.Support.Mocks do
  # TODO use this module or lose it
  alias SuperSeed.SideEffectsWrapper

  def use_real_config do
    Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
      Application.get_all_env(:super_seed)
    end)

    Mimic.expect(SideEffectsWrapper, :application_get_key, 1, fn :super_seed, :modules ->
      :application.get_key(:super_seed, :modules)
    end)
  end
end
