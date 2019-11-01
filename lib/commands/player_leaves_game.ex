alias Commanded.Aggregate.Multi


defmodule Chifoumi.PlayerLeavesGame do
  defstruct [:game_id, :player_id]


  def execute(game, command) do
    cond do
      game.game_id == nil ->
        {:error, :game_not_found}

      not Enum.member?(game.player_ids, command.player_id) ->
        {:error, :player_not_found}

      true ->
        game
          |> Multi.new()
          |> Multi.execute(&player_leaves_game(&1, command))
          |> Multi.execute(&cancel_game_if_needed(&1, command))
    end
  end


  defp player_leaves_game(_game, command) do
    %Chifoumi.PlayerLeftGame{
      game_id: command.game_id,
      player_id: command.player_id
    }
  end


  defp cancel_game_if_needed(game, command) do
    if game.player_ids == [] or Enum.any?(game.wins) do
      %Chifoumi.GameCancelled{game_id: command.game_id}
    end
  end
end
