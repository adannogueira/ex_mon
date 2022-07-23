# Creating a Struct
defmodule ExMon.Player do
  # Creating module variables
  @required_keys [:life, :moves, :name]

  # Defining a module attribute and giving external access to it
  @max_life 100
  def max_life, do: @max_life

  # Making keys mandatory
  @enforce_keys @required_keys

  # Defining attributes
  defstruct @required_keys

  # Building the struct with default values
  @doc """
  To use the build, simply do
    iex> ExMon.Player.build("Name", :move1, :move2, :move3)
  """
  def build(name, move_rnd, move_avg, move_heal) do
    %ExMon.Player{
      life: @max_life,
      moves: %{
        move_avg: move_avg,
        move_heal: move_heal,
        move_rnd: move_rnd,
      },
      name: name
    }
  end
end
