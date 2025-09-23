defmodule SuperSeed.Init.ModuleNamespaceTest do
  use ExUnit.Case, async: true

  describe "filter/2" do
    test "filters modules that match the given namespace" do
      assert SuperSeed.Init.ModuleNamespace.filter(
               [
                 MyApp.User,
                 MyApp.Post,
                 OtherApp.User,
                 MyApp.User.Profile
               ],
               MyApp
             ) ==
               [MyApp.User, MyApp.Post, MyApp.User.Profile]
    end

    test "returns empty list when no modules match namespace" do
      assert SuperSeed.Init.ModuleNamespace.filter([OtherApp.User, ThirdApp.Post], MyApp) == []
    end

    test "returns empty list when given empty module list" do
      assert SuperSeed.Init.ModuleNamespace.filter([], MyApp) == []
    end

    test "handles nested namespace filtering correctly" do
      assert SuperSeed.Init.ModuleNamespace.filter(
               [
                 MyApp.User.Profile,
                 MyApp.Post,
                 OtherApp.User
               ],
               MyApp.User
             ) == [MyApp.User.Profile]
    end

    test "requires exact namespace match with dot separator" do
      assert SuperSeed.Init.ModuleNamespace.filter(
               [
                 MyApp.User,
                 MyAppExtended.User,
                 MyApp123.User
               ],
               MyApp
             ) == [MyApp.User]
    end

    test "handles single word namespace" do
      assert SuperSeed.Init.ModuleNamespace.filter([User, App.User, Other.Post], App) == [App.User]
    end

    test "module filtering works with module names prefixed with Elixir" do
      assert SuperSeed.Init.ModuleNamespace.filter(
               [
                 :"Elixir.MyApp.User",
                 :"Elixir.MyApp.Post",
                 :"Elixir.OtherApp.User",
                 :"Elixir.MyApp.User.Profile",
                 MyApp.User.Timeline
               ],
               MyApp
             ) ==
               [:"Elixir.MyApp.User", :"Elixir.MyApp.Post", :"Elixir.MyApp.User.Profile", MyApp.User.Timeline]
    end
  end
end
