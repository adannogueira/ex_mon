defmodule ExMon do
  # Creating an alias to shorten module calls, it's possible to use :as to assign a different alias
  alias ExMon.{Game, Player}
  alias ExMon.Game.{Actions, Status}

  @computer_name "Gary"
  @computer_moves [:move_avg, :move_rnd, :move_heal]

  def start_game(name, move_rnd, move_avg, move_heal) do
    player = create_player(name, move_rnd, move_avg, move_heal)
    @computer_name
    |> create_player(:punch, :kick, :heal)
    |> Game.start(player)

    Status.print_round_message(Game.info())
    computer_move(Game.info())
  end

  def make_move(move) do
    Game.info()
    |> Map.get(:status)
    |> handle_status(move)
  end

  defp create_player(name, move_rnd, move_avg, move_heal) do
    # Using the alias you avoid the long ExMon.Player.build() call
    Player.build(name, move_rnd, move_avg, move_heal)
  end

  defp handle_status(:game_over, _move), do: Status.print_round_message(Game.info())
  defp handle_status(_other, move) do
    move
    |> Actions.fetch_move()
    |> do_move()

    computer_move(Game.info())
  end

  defp do_move({:error, move}), do: Status.print_wrong_move_message(move)
  defp do_move({:ok, move}) do
    case move do
      :move_heal -> Actions.heal()
      move -> Actions.attack(move)
    end

    Status.print_round_message(Game.info())
  end

  defp computer_move(%{turn: :computer, status: :continue}) do
    Game.info()
    |> Map.get(:computer, :life)
    |> choose_attack_heal(@computer_moves)
  end

  defp computer_move(%{turn: :computer, status: :started}) do
    Status.surprise_message()
    move = {:ok, Enum.random([:move_avg, :move_rnd])}
    do_move(move)
  end

  defp computer_move(_), do: :ok

  def choose_attack_heal(life, moves) when life > 80, do: do_move({:ok, Enum.random(moves -- [:move_heal])})
  def choose_attack_heal(life, moves) when life < 40, do: do_move({:ok, Enum.random(moves ++ [:move_heal])})
  def choose_attack_heal(_, moves), do: do_move({:ok, Enum.random(moves)})

end
