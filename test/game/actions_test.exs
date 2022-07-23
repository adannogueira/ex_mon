defmodule Game.ActionsTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.Game
  alias ExMon.Game.Actions

  describe "attack/1" do
    setup do
      capture_io(fn ->
        ExMon.start_game("Red", :rnd, :avg, :heal)
      end)
      :ok # The setup will always expect some result that can be passed to test cases
    end
    test "should not target the turn owner player" do
      turn_owner = Game.turn()
      starting_life = ExMon.Game.fetch_player(turn_owner)
      |> Map.get(:life)
      capture_io(fn -> Actions.attack(:move_rnd) end)
      resulting_life = ExMon.Game.fetch_player(turn_owner)
        |> Map.get(:life)

      assert resulting_life == starting_life
    end

    test "should lower the other player life" do
      turn_owner = Game.turn()
      capture_io(fn -> Actions.attack(:move_rnd) end)
      resulting_life = ExMon.Game.fetch_player(:computer)
        |> Map.get(:life)

      assert resulting_life < ExMon.Player.max_life()
      assert turn_owner != :computer
    end
  end

  describe "heal/0" do
    setup do
      capture_io(fn ->
        ExMon.start_game("Red", :rnd, :avg, :heal)
      end)
      :ok
    end
    test "should increase turn owner's life" do
      max_life = ExMon.Player.max_life()
      ExMon.Game.info()
      |> put_in([Access.key!(:computer), Access.key!(:life)], max_life - 10)
      |> ExMon.Game.update()
      turn_owner = Game.turn()
      capture_io(fn -> Actions.heal() end)
      resulting_life = ExMon.Game.fetch_player(turn_owner)
        |> Map.get(:life)

      assert resulting_life == max_life
      assert turn_owner == :computer
    end
  end

  describe "fetch_move/1" do
    setup do
      capture_io(fn ->
        ExMon.start_game("Red", :rnd, :avg, :hea)
      end)
      :ok
    end
    test "should return the move associated with the alias" do
      assert Actions.fetch_move(:rnd) == {:ok, :move_rnd }
      assert Actions.fetch_move(:avg) == {:ok, :move_avg }
      assert Actions.fetch_move(:hea) == {:ok, :move_heal }
    end

    test "should return an error when no move is found" do
      assert Actions.fetch_move(:invalid) == {:error, :invalid }
    end
  end
end
