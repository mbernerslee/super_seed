defmodule SuperSeed.InserterWorkersStatusTest do
  use ExUnit.Case, async: true
  alias SuperSeed.InserterWorkersStatus

  describe "determine/1" do
    test "returns :running when any worker has :pending status" do
      workers = %{
        A => %{status: :finished},
        B => %{status: :finished},
        C => %{status: :pending}
      }

      assert InserterWorkersStatus.determine(workers) == :running
    end

    test "returns :running when any worker has :running status" do
      workers = %{
        A => %{status: :finished},
        B => %{status: :running},
        C => %{status: :finished}
      }

      assert InserterWorkersStatus.determine(workers) == :running
    end

    test "returns :running when multiple workers have :running status" do
      workers = %{
        A => %{status: :running},
        B => %{status: :running},
        C => %{status: :finished}
      }

      assert InserterWorkersStatus.determine(workers) == :running
    end

    test "returns :running when workers have mix of :pending and :running" do
      workers = %{
        A => %{status: :pending},
        B => %{status: :running},
        C => %{status: :finished}
      }

      assert InserterWorkersStatus.determine(workers) == :running
    end

    test "returns :running even when error workers are present" do
      workers = %{
        A => %{status: :pending},
        B => %{status: :error},
        C => %{status: :halted}
      }

      assert InserterWorkersStatus.determine(workers) == :running
    end

    test "returns {:finished, :error} when all workers are finished but some halted" do
      workers = %{
        A => %{status: :finished},
        B => %{status: :halted},
        C => %{status: :finished}
      }

      assert InserterWorkersStatus.determine(workers) == {:finished, :error}
    end

    test "returns {:finished, :error} when all workers are finished but some errored" do
      workers = %{
        A => %{status: :finished},
        B => %{status: :error},
        C => %{status: :finished}
      }

      assert InserterWorkersStatus.determine(workers) == {:finished, :error}
    end

    test "returns {:finished, :error} when all workers are finished but some halted and errored" do
      workers = %{
        A => %{status: :finished},
        B => %{status: :error},
        C => %{status: :halted}
      }

      assert InserterWorkersStatus.determine(workers) == {:finished, :error}
    end

    test "returns {:finished, :error} when workers have mix of :error and :halted" do
      workers = %{
        A => %{status: :error},
        B => %{status: :halted},
        C => %{status: :error}
      }

      assert InserterWorkersStatus.determine(workers) == {:finished, :error}
    end

    test "returns {:finished, :ok} when all workers have :finished status" do
      workers = %{
        A => %{status: :finished},
        B => %{status: :finished},
        C => %{status: :finished}
      }

      assert InserterWorkersStatus.determine(workers) == {:finished, :ok}
    end

    test "returns {:finished, :ok} when single worker has :finished status" do
      workers = %{
        A => %{status: :finished}
      }

      assert InserterWorkersStatus.determine(workers) == {:finished, :ok}
    end

    test "returns {:finished, :ok} when no workers provided" do
      workers = %{}

      assert InserterWorkersStatus.determine(workers) == {:finished, :ok}
    end
  end
end
