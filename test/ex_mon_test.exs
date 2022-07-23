defmodule ExMonTest do
  use ExUnit.Case

  # To test IO returns we need to capture them
  import ExUnit.CaptureIO

  describe "start_game/4" do
    test "returns a message when game starts" do
      # The IO message is captured in a variable
      message = capture_io(fn ->
        # The original return is passed to a function
        assert ExMon.start_game("Red", :rnd, :avg, :heal) == :ok
      end)

      # Using the =~ to assert a RegExp (partial response match)
      assert message =~ "Game Started!"
    end
  end

  describe "make_move/1" do
    # Creating a test setup (all code inside runs before every test inside the describe)
    setup do
      capture_io(fn ->
        ExMon.start_game("Red", :kick, :punch, :heal)
      end)
      :ok # The setup will always expect some result that can be passed to test cases
    end
    test "when the move is valid, execute the move" do
      message = capture_io(fn -> ExMon.make_move(:kick) end)

      assert message =~ "The Player attacked the computer"
    end

    test "when the move is invalid, returns an error message" do
      message = capture_io(fn -> ExMon.make_move(:invalid) end)

      assert message =~ "Invalid move: invalid"
    end
  end
end
