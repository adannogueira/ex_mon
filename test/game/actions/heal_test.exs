defmodule Game.Actions.HealTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.Game.Actions.Heal

  describe "heal_life/1" do
    setup do
      capture_io(fn ->
        ExMon.start_game("Red", :rnd, :avg, :heal)
      end)
      :ok # The setup will always expect some result that can be passed to test cases
    end
    test "should increase target life between 18..35 points" do
      ExMon.Game.info()
      |> put_in([Access.key!(:player), Access.key!(:life)], 65)
      |> ExMon.Game.update()
      capture_io(fn -> Heal.heal_life(:player) end)
      resulting_life = ExMon.Game.player()
        |> Map.get(:life)

      assert Enum.member?(83..100, resulting_life)
    end

    test "should not increase target life above Player.max_life" do
      max_life = ExMon.Player.max_life()
      ExMon.Game.info()
      |> put_in([Access.key!(:player), Access.key!(:life)], max_life - 3)
      |> ExMon.Game.update()
      capture_io(fn -> Heal.heal_life(:player) end)
      resulting_life = ExMon.Game.player()
        |> Map.get(:life)

      assert resulting_life == max_life
    end
  end
end
