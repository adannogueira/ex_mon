defmodule ExMon.GameTest do
  use ExUnit.Case

  alias ExMon.{Player, Game}

  describe "start/2" do
    test "starts the game state" do
      player = Player.build("Red", :kick, :punch, :heal)
      computer = Player.build("Blue", :kick, :punch, :heal)

      # An assertion can also use pattern matching, in this case,
      # the _pid is variable, so we test the :ok, the match must come first
      assert {:ok, _pid} = Game.start(player, computer)
    end
  end

  describe "info/0" do
    test "returns the current game state" do
      player = Player.build("Red", :kick, :punch, :heal)
      computer = Player.build("Blue", :kick, :punch, :heal)
      Game.start(computer, player)

      expected_response = %{
        computer: %Player{
          life: 100,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Blue"
        },
        player: %Player{
          life: 100,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Red"
        },
        status: :started,
      }

      assert expected_response
        |> Map.to_list()
        |> Enum.all?(&(&1 in Game.info()))
    end
  end

  describe "update/1" do
    test "returns the updated game state" do
      player = Player.build("Red", :kick, :punch, :heal)
      computer = Player.build("Blue", :kick, :punch, :heal)
      Game.start(computer, player)

      old_state = %{
        computer: %Player{
          life: 100,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Blue"
        },
        player: %Player{
          life: 100,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Red"
        },
        status: :started,
      }

      assert old_state
        |> Map.to_list()
        |> Enum.all?(&(&1 in Game.info))

      new_state = %{
        computer: %Player{
          life: 90,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Blue"
        },
        player: %Player{
          life: 60,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Red"
        },
        status: :continue,
        turn: :player
      }

      Game.update(new_state)
      expected_response = %{new_state | turn: :computer}

      assert Game.info() == expected_response
    end
  end

  describe "player/0" do
    test "returns the player tuple" do
      player = Player.build("Red", :kick, :punch, :heal)
      computer = Player.build("Blue", :kick, :punch, :heal)
      Game.start(computer, player)

      assert Game.player() == %Player{
               life: 100,
               moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
               name: "Red"
             }
    end
  end

  describe "turn/0" do
    test "returns the current turn information changed after each update" do
      player = Player.build("Red", :kick, :punch, :heal)
      computer = Player.build("Blue", :kick, :punch, :heal)
      Game.start(computer, player)
      current_turn = Game.turn()

      new_state = %{
        computer: %Player{
          life: 90,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Blue"
        },
        player: %Player{
          life: 60,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Red"
        },
        status: :start,
        turn: current_turn
      }

      Game.update(new_state)

      assert Game.turn() != current_turn
    end
  end

  describe "fetch_player/1" do
    test "returns the correct player info" do
      player = Player.build("Red", :kick, :punch, :heal)
      computer = Player.build("Blue", :kick, :punch, :heal)
      Game.start(computer, player)

      assert Game.fetch_player(:computer) == %Player{
               life: 100,
               moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
               name: "Blue"
             }
      assert Game.fetch_player(:player) == %Player{
              life: 100,
              moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
              name: "Red"
            }
    end
  end
end
