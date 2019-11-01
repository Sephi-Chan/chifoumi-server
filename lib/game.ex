defmodule Chifoumi.Game do
  defstruct [:game_id, :player_ids, :round, :wins, :target_score, :status]


  def execute(game, command) do
    command.__struct__.execute(game, command)
  end


  def apply(game, event) do
    event.__struct__.apply(game, event)
  end


  def winner(wins, target_score) do
    Enum.find(wins, fn (maybe_winner_id) ->
      target_score == Enum.count(wins, fn (winner_id) -> winner_id == maybe_winner_id end)
    end)
  end
end
