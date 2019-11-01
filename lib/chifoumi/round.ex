defmodule Chifoumi.Round do
  def all_players_played?(round) do
    Enum.all?(round, fn({_player_id, shape}) -> shape != nil end)
  end


  def winner(round) do
    [shape, other_shape] = Map.values(round)
    winning_shape = Chifoumi.Shape.winner(shape, other_shape)
    player_by_shape = Map.new(round, fn {player_id, shape} -> {shape, player_id} end)
    player_by_shape[winning_shape]
  end
end
