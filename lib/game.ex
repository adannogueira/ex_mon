# Creating an Agent to control flow
defmodule ExMon.Game do
  alias ExMon.Player
  alias ExMon.Game.Status

  use Agent

  @players [:player, :computer]

  def start(computer, player) do
    random_starter = Enum.random(@players)
    initial_value = %{
      computer: computer,
      player: player,
      turn: random_starter,
      status: :started
    }

    # Starting the agent with an initial value
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def info do
    # Getting current agent state (the __MODULE__ refers to self name)
    Agent.get(__MODULE__, & &1)
  end

  def update(state) do
    # When you want to ignore a parameter, use the "_", like so
    Agent.update(__MODULE__, fn _ -> update_game_status(state) end)
  end

  def player, do: Map.get(info(), :player)

  def turn, do: Map.get(info(), :turn)

  def fetch_player(player), do: Map.get(info(), player)

  # Destructuring parameter using pattern matching
  defp update_game_status(%{player: %Player{life: player_life}, computer: %Player{life: computer_life}} = state)
    when player_life < 1 or computer_life < 1, do: end_game(state)

  defp update_game_status(state) do
    state
    |> Map.put(:status, :continue)
    |> update_turn()
  end

  defp update_turn(%{turn: :player} = state), do: Map.put(state, :turn, :computer)
  defp update_turn(%{turn: :computer} = state), do: Map.put(state, :turn, :player)

  defp end_game(%{computer: %Player{life: 0}} = state) do
    Status.winner_is(:player)
    Map.put(state, :status, :game_over)
  end
  defp end_game(%{player: %Player{life: 0}} = state) do
    Status.winner_is(:computer)
    Map.put(state, :status, :game_over)
  end
end
