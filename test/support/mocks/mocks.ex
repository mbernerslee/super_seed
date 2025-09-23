defmodule SuperSeed.Support.Mocks do
  alias SuperSeed.SideEffectsWrapper

  def use_real_config do
    Mimic.expect(SideEffectsWrapper, :application_get_all_env, 1, fn :super_seed ->
      Application.get_all_env(:super_seed)
    end)

    Mimic.expect(SideEffectsWrapper, :application_get_key, 1, fn :super_seed, :modules ->
      :application.get_key(:super_seed, :modules)
    end)

    Mimic.expect(SideEffectsWrapper, :application_ensure_all_started, 1, fn :super_seed ->
      Application.ensure_all_started(:super_seed)
    end)
  end
end
