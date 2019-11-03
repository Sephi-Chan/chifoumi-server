defmodule Chifoumi.PlayerCreatesGame do
  defstruct [:game_id, :creator_id, :target_score]

  def execute(%Chifoumi.Game{game_id: nil}, command) do
    %Chifoumi.GameCreated{
      game_id: command.game_id,
      creator_id: command.creator_id,
      target_score: command.target_score
    }
  end


  def execute(_game, _command) do
    {:error, :game_id_is_taken}
  end
end
