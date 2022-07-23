# Setting a new namespace
defmodule ExMon.Game.Status do
  def print_round_message(%{status: :started}) do
    # Printing to the console
    IO.puts("\n========================= Game Started! =========================\n")
  end

  def print_round_message(%{status: :continue, turn: player} = info) do
    # Printing to the console
    info
    |> Map.get(player)
    |> Map.get(:name)
    |> get_name()
    |> IO.puts()
    print_status(info)
    IO.puts("-----------------------------------------------------------------")
  end

  def print_round_message(%{status: :game_over}) do
    # Printing to the console
    IO.puts("\n======================= The game is over! =======================\n")
  end

  def print_wrong_move_message(move) do
    IO.puts("\n!!! Invalid move: #{move} !!!\n")
  end

  def print_move_message(:computer, :attack, damage) do
    IO.puts("\n====== The Player attacked the computer dealing #{damage} damage. ======\n")
  end

  def print_move_message(:player, :attack, damage) do
    IO.puts("\n====== The Computer attacked the player dealing #{damage} damage. ======\n")
  end

  def print_move_message(player, :heal, life) do
    IO.puts("\n>>> The #{player} has healed itself to #{life} life points.\n")
  end

  def surprise_message(), do: IO.puts("\n================ The enemy gets you by surprise =================\n")

  def winner_is(:computer), do: IO.puts("================== The Computer Won This One! ===================")
  def winner_is(:player), do: IO.puts("================== Congratulations! You Won!! ===================")

  defp get_name(player), do: "\n>>> It's #{player}'s turn!\n"

  defp print_status(state) do
    player = Map.get(state, :player)
    computer = Map.get(state, :computer)
    IO.puts("*** #{Map.get(player, :name)}'s life at #{Map.get(player, :life)}")
    IO.puts("*** #{Map.get(computer, :name)}'s life at #{Map.get(computer, :life)}")
  end
end
