defmodule Game.Actions.AttackTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.Game.Actions.Attack
  alias ExMon.Game

  describe "attack_opponent/2" do
    setup do
      capture_io(fn ->
        ExMon.start_game("Red", :rnd, :avg, :heal)
      end)
      :ok # The setup will always expect some result that can be passed to test cases
    end

    test "should lower the target life between 10..35 with move_rnd" do
      capture_io(fn -> Attack.attack_opponent(:computer, :move_rnd) end)
      resulting_life = ExMon.Game.fetch_player(:computer)
        |> Map.get(:life)

      assert Enum.member?(65..90, resulting_life)
    end

    test "should lower the target life between 10..35 with move_avg" do
      capture_io(fn -> Attack.attack_opponent(:computer, :move_avg) end)
      resulting_life = ExMon.Game.fetch_player(:computer)
        |> Map.get(:life)

      assert Enum.member?(75..82, resulting_life)
    end
  end
end
