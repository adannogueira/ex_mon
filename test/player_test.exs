defmodule PlayerTest do
  use ExUnit.Case

  alias ExMon.Player

  describe "build/4" do
    test "should return a player" do
      expected_return = %Player{
        life: 100,
        moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
        name: "Red"
      }

      assert expected_return == Player.build("Red", :kick, :punch, :heal)
    end
  end
end
