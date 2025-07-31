defmodule SuperSeed.InserterModulesValidatorTest do
  use ExUnit.Case, async: true
  alias SuperSeed.InserterModulesValidator

  alias SuperSeed.Support.Inserters.{
    Farms,
    MinimumValid,
    Empty,
    MissingDependsOn,
    MissingTable,
    WrongArityTable,
    WrongArityDependsOn,
    WrongArityInsert
  }

  describe "validate/1" do
    test "given a module which contains the mandatory inserter module functions, return ok" do
      assert :ok == InserterModulesValidator.validate([MinimumValid])
      assert :ok == InserterModulesValidator.validate([MinimumValid, Farms])
    end

    test "malformed inserter module error cases" do
      cases = [
        Empty,
        MissingDependsOn,
        MissingTable,
        WrongArityTable,
        WrongArityDependsOn,
        WrongArityInsert
      ]

      Enum.each(cases, fn module ->
        assert {:error, {:inserter_module_validation, module, :malformed}} ==
                 InserterModulesValidator.validate([module]),
               "expected #{module} to error"
      end)
    end
  end
end
