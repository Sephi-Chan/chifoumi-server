defmodule Chifoumi.PlayerJoinsGame do
  defstruct [:game_id, :player_id]


  def execute(game, command) do
    cond do
      game.game_id == nil ->
        {:error, :game_not_found}

      Enum.member?(game.player_ids, command.player_id) ->
        {:error, :already_joined}

      length(game.player_ids) == 2 ->
        {:error, :already_two_players}

      true ->
        %Chifoumi.PlayerJoined{
          game_id: command.game_id,
          player_id: command.player_id
        }
    end
  end
end
