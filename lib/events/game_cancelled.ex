defmodule Chifoumi.GameCancelled do
  @derive Jason.Encoder
  defstruct [:game_id]


  def apply(game, _event) do
    %{game | status: "cancelled"}
  end
end
