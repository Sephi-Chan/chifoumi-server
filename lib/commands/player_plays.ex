alias Commanded.Aggregate.Multi


defmodule Chifoumi.PlayerPlays do
  defstruct [:game_id, :player_id, :shape]


  def execute(game, command) do
    cond do
      game.game_id == nil ->
        {:error, :game_not_found}

      game.status == "waiting_for_opponent" ->
        {:error, :game_not_started}

      not Enum.member?(game.player_ids, command.player_id) ->
        {:error, :player_not_found}

      game.status == "finished" ->
        {:error, :game_is_finished}

      game.round[command.player_id] ->
        {:error, :already_played}

      true ->
        game
          |> Multi.new()
          |> Multi.execute(&play_shape(&1, command))
          |> Multi.execute(&end_round_or_game_if_needed(&1, command))
        end
  end


  defp play_shape(_game, command) do
    %Chifoumi.PlayerPlayed{
      game_id: command.game_id,
      player_id: command.player_id,
      shape: command.shape
    }
  end


  defp end_round_or_game_if_needed(game, command) do
    if Chifoumi.Round.all_players_played?(game.round) do
      case Chifoumi.Round.winner(game.round) do
        nil ->
          %Chifoumi.RoundTied{game_id: command.game_id}

        round_winner_id ->
          case Chifoumi.Game.winner(game.wins ++ [round_winner_id], game.target_score) do
            nil ->
              %Chifoumi.RoundEnded{game_id: command.game_id, winner_id: round_winner_id}

            game_winner_id ->
              %Chifoumi.GameEnded{game_id: command.game_id, winner_id: game_winner_id}
          end
      end
    end
  end
end
