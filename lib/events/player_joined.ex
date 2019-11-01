defmodule Chifoumi.PlayerJoined do
  @derive Jason.Encoder
  defstruct [:game_id, :player_id]


  def apply(game, event) do
    %Chifoumi.Game{game |
      player_ids: game.player_ids ++ [event.player_id],
      round: Map.put(game.round, event.player_id, nil),
      status: "waiting_player_actions"
    }
  end
end
