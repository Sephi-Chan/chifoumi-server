defmodule Chifoumi.PlayerLeftGame do
  @derive Jason.Encoder
  defstruct [:game_id, :player_id]


  def apply(game, event) do
    %Chifoumi.Game{game |
      player_ids: List.delete(game.player_ids, event.player_id),
      round: Map.delete(game.round, event.player_id),
      status: "waiting_for_opponent"
    }
  end
end
