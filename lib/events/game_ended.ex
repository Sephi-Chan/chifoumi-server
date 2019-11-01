defmodule Chifoumi.GameEnded do
  @derive Jason.Encoder
  defstruct [:game_id, :winner_id]


  def apply(game, _event) do
    %{game | status: "finished"}
  end
end
