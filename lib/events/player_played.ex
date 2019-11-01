defmodule Chifoumi.PlayerPlayed do
  @derive Jason.Encoder
  defstruct [:game_id, :player_id, :shape]


  def apply(game, event) do
    %{game | round: Map.put(game.round, event.player_id, event.shape)}
  end
end
