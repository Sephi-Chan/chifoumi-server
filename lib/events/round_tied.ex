defmodule Chifoumi.RoundTied do
  @derive Jason.Encoder
  defstruct [:game_id]


  def apply(game, _event) do
    %{game | round: Map.new(game.player_ids, fn (player_id) -> {player_id, nil} end)}
  end
end
