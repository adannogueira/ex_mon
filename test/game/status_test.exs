defmodule Game.StatusTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.Game.Status

  describe "print_round_message/1" do
    setup do
      message = capture_io(fn ->
        ExMon.start_game("Red", :rnd, :avg, :heal)
      end)
      {:ok, message: message} # The setup will always expect some result that can be passed to test cases
    end
    test "should print game started message when status is :started", %{message: message} do
      assert message =~ "Game Started!"
    end

    test "should print player name on new turn" do
      message = capture_io(fn ->
        ExMon.Game.info()
        |> Map.put(:status, :continue)
        |> Map.put(:turn, :player)
        |> Status.print_round_message()
      end)

      assert message =~ ">>> It's Red's turn!"
      assert message =~ "*** Red's life at"
    end

    test "should print game over message" do
      message = capture_io(fn ->
        ExMon.Game.info()
        |> Map.put(:status, :game_over)
        |> Status.print_round_message()
      end)

      assert message =~ "The game is over!"
    end
  end

  describe "print_wrong_move_message/1" do
    test "should print wrong move message" do
      message = capture_io(fn ->
        Status.print_wrong_move_message(:invalid)
      end)

      assert message =~ "!!! Invalid move: invalid !!!"
    end
  end

  describe "print_move_message/3" do
    test "should print correct move message when :computer is target" do
      message = capture_io(fn ->
        Status.print_move_message(:computer, :attack, 10)
      end)

      assert message =~ "The Player attacked the computer dealing 10 damage."
    end

    test "should print correct move message when :player is target" do
      message = capture_io(fn ->
        Status.print_move_message(:player, :attack, 10)
      end)

      assert message =~ "The Computer attacked the player dealing 10 damage."
    end

    test "should print correct move message when :heal is used" do
      message = capture_io(fn ->
        Status.print_move_message(:player, :heal, 100)
      end)

      assert message =~ "The player has healed itself to 100 life points."
    end
  end

  describe "surprise_message/0" do
    test "should print correct message" do
      message = capture_io(fn ->
        Status.surprise_message()
      end)
      assert message =~ "The enemy gets you by surprise"
    end
  end

  describe "winner_is/1" do
    test "should print player victory" do
      message = capture_io(fn ->
        Status.winner_is(:player)
      end)

      assert message =~ "Congratulations! You Won!!"
    end

    test "should print computer victory" do
      message = capture_io(fn ->
        Status.winner_is(:computer)
      end)

      assert message =~ "The Computer Won This One!"
    end
  end
end
