defmodule Chifoumi.RoundEnded do
  @derive Jason.Encoder
  defstruct [:game_id, :winner_id]


  def apply(game, event) do
    %{game |
      round: Map.new(game.player_ids, fn (player_id) -> {player_id, nil} end),
      wins: game.wins ++ [event.winner_id]
    }
  end
end
