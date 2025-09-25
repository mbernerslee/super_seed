defmodule SuperSeed.DependencyResolverTest do
  use ExUnit.Case, async: true
  alias SuperSeed.DependencyResolver

  describe "resolve/1" do
    test "resolves dependencies for single inserter with no dependencies" do
      inserters = [
        {A, "table_a", []}
      ]

      expected = %{
        A => MapSet.new([])
      }

      assert DependencyResolver.resolve(inserters) == expected
    end

    test "resolves dependencies for inserter depending on table" do
      inserters = [
        {A, "table_a", []},
        {B, "table_b", [{:table, "table_a"}]}
      ]

      expected = %{
        A => MapSet.new([]),
        B => MapSet.new([A])
      }

      assert DependencyResolver.resolve(inserters) == expected
    end

    test "resolves dependencies for inserter depending on another inserter" do
      inserters = [
        {A, "table_a", []},
        {B, "table_b", [{:inserter, A}]}
      ]

      expected = %{
        A => MapSet.new([]),
        B => MapSet.new([A])
      }

      assert DependencyResolver.resolve(inserters) == expected
    end

    test "resolves dependencies for multiple inserters on same table" do
      inserters = [
        {A, "table_a", []},
        {B, "table_a", []},
        {C, "table_b", [{:table, "table_a"}]}
      ]

      expected = %{
        A => MapSet.new([]),
        B => MapSet.new([]),
        C => MapSet.new([A, B])
      }

      assert DependencyResolver.resolve(inserters) == expected
    end

    test "resolves mixed dependencies (table and inserter)" do
      inserters = [
        {A, "table_a", []},
        {B, "table_b", []},
        {C, "table_c", [{:table, "table_a"}, {:inserter, B}]}
      ]

      expected = %{
        A => MapSet.new([]),
        B => MapSet.new([]),
        C => MapSet.new([A, B])
      }

      assert DependencyResolver.resolve(inserters) == expected
    end

    test "resolves complex dependency chain" do
      inserters = [
        {A, "table_a", []},
        {B, "table_b", [{:table, "table_a"}]},
        {C, "table_c", [{:table, "table_b"}]},
        {D, "table_d", [{:inserter, A}, {:table, "table_c"}]}
      ]

      expected = %{
        A => MapSet.new([]),
        B => MapSet.new([A]),
        C => MapSet.new([B]),
        D => MapSet.new([A, C])
      }

      assert DependencyResolver.resolve(inserters) == expected
    end

    test "handles empty inserter data" do
      assert DependencyResolver.resolve([]) == %{}
    end

    test "handles multiple dependencies of same type" do
      inserters = [
        {A, "table_a", []},
        {B, "table_b", []},
        {C, "table_c", []},
        {D, "table_d", [{:inserter, A}, {:inserter, B}, {:inserter, C}]}
      ]

      expected = %{
        A => MapSet.new([]),
        B => MapSet.new([]),
        C => MapSet.new([]),
        D => MapSet.new([A, B, C])
      }

      assert DependencyResolver.resolve(inserters) == expected
    end

    test "depending on a table, which has multiple inserters, means we're dependent on all of them" do
      inserters = [
        {A1, "table_a", []},
        {A2, "table_a", []},
        {A3, "table_a", []},
        {B, "table_b", [{:table, "table_a"}]}
      ]

      expected = %{
        A1 => MapSet.new([]),
        A2 => MapSet.new([]),
        A3 => MapSet.new([]),
        B => MapSet.new([A1, A2, A3])
      }

      assert DependencyResolver.resolve(inserters) == expected
    end
  end
end
