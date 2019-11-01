defmodule Chifoumi.GameCreated do
  @derive Jason.Encoder
  defstruct [:game_id, :creator_id, :target_score]


  def apply(game, event) do
    %Chifoumi.Game{game |
      game_id: event.game_id,
      player_ids: [event.creator_id],
      round: %{event.creator_id => nil},
      wins: [],
      target_score: event.target_score,
      status: "waiting_for_opponent"
    }
  end
end
