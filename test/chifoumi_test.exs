import Commanded.Assertions.EventAssertions


defmodule ChifoumiTest do
  use Chifoumi.DatabaseCase


  test "Player creates a game. The game is not playable yet." do
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerCreatesGame{game_id: "42", creator_id: "Corwin", target_score: 3})
    {:error, :game_not_started} = Chifoumi.Application.dispatch(%Chifoumi.PlayerPlays{game_id: "42", player_id: "Corwin", shape: "rock"})
  end


  test "Player can't reuse the same ID." do
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerCreatesGame{game_id: "42", creator_id: "Corwin", target_score: 3})
    {:error, :game_id_is_taken} = Chifoumi.Application.dispatch(%Chifoumi.PlayerCreatesGame{game_id: "42", creator_id: "Corwin", target_score: 3})
  end


  test "Player can join a game once. Only two players per game." do
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerCreatesGame{game_id: "42", creator_id: "Corwin", target_score: 3})
    {:error, :already_joined} = Chifoumi.Application.dispatch(%Chifoumi.PlayerJoinsGame{game_id: "42", player_id: "Corwin"})
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerJoinsGame{game_id: "42", player_id: "Mandor"})
    {:error, :already_joined} = Chifoumi.Application.dispatch(%Chifoumi.PlayerJoinsGame{game_id: "42", player_id: "Mandor"})
    {:error, :already_two_players} = Chifoumi.Application.dispatch(%Chifoumi.PlayerJoinsGame{game_id: "42", player_id: "Eric"})
  end


  test "An inexisting game can't receive commands." do
    {:error, :game_not_found} = Chifoumi.Application.dispatch(%Chifoumi.PlayerJoinsGame{game_id: "42", player_id: "Corwin"})
    {:error, :game_not_found} = Chifoumi.Application.dispatch(%Chifoumi.PlayerPlays{game_id: "42", player_id: "Mandor", shape: "rock"})
    {:error, :game_not_found} = Chifoumi.Application.dispatch(%Chifoumi.PlayerLeavesGame{game_id: "42", player_id: "Mandor"})
  end


  test "A player can leave the game." do
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerCreatesGame{game_id: "42", creator_id: "Corwin", target_score: 3})
    {:error, :player_not_found} = Chifoumi.Application.dispatch(%Chifoumi.PlayerLeavesGame{game_id: "42", player_id: "Eric"})
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerJoinsGame{game_id: "42", player_id: "Mandor"})
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerLeavesGame{game_id: "42", player_id: "Mandor"})
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerJoinsGame{game_id: "42", player_id: "Mandor"})
  end


  test "A game is cancelled when the creator leave before someone had the chance to join." do
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerCreatesGame{game_id: "42", creator_id: "Corwin", target_score: 3})
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerLeavesGame{game_id: "42", player_id: "Corwin"})
    assert_receive_event(Chifoumi.Application, Chifoumi.GameCancelled, fn (event) -> event.game_id == "42" end, &(&1))
  end


  test "A game with no more player is cancelled." do
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerCreatesGame{game_id: "42", creator_id: "Corwin", target_score: 3})
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerJoinsGame{game_id: "42", player_id: "Mandor"})
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerLeavesGame{game_id: "42", player_id: "Mandor"})
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerLeavesGame{game_id: "42", player_id: "Corwin"})
    assert_receive_event(Chifoumi.Application, Chifoumi.GameCancelled, fn (event) -> event.game_id == "42" end, &(&1))
  end


  test "A game is cancelled when it started (someone scored a point) and any player leaves" do
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerCreatesGame{game_id: "42", creator_id: "Corwin", target_score: 3})
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerJoinsGame{game_id: "42", player_id: "Mandor"})
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerPlays{game_id: "42", player_id: "Corwin", shape: "paper"})
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerPlays{game_id: "42", player_id: "Mandor", shape: "rock"})
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerLeavesGame{game_id: "42", player_id: "Corwin"})
    assert_receive_event(Chifoumi.Application, Chifoumi.GameCancelled, fn (event) -> event.game_id == "42" end, &(&1))
  end


  test "Only the creator and the player who joined can play." do
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerCreatesGame{game_id: "42", creator_id: "Corwin", target_score: 3})
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerJoinsGame{game_id: "42", player_id: "Mandor"})
    {:error, :player_not_found} = Chifoumi.Application.dispatch(%Chifoumi.PlayerPlays{game_id: "42", player_id: "Eric", shape: "rock"})
  end


  test "Corwin wins the game" do
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerCreatesGame{game_id: "42", creator_id: "Corwin", target_score: 3})
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerJoinsGame{game_id: "42", player_id: "Mandor"})

    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerPlays{game_id: "42", player_id: "Corwin", shape: "rock"})
    {:error, :already_played} = Chifoumi.Application.dispatch(%Chifoumi.PlayerPlays{game_id: "42", player_id: "Corwin", shape: "rock"})
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerPlays{game_id: "42", player_id: "Mandor", shape: "rock"})
    assert_receive_event(Chifoumi.Application, Chifoumi.RoundTied, &(&1))

    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerPlays{game_id: "42", player_id: "Corwin", shape: "paper"})
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerPlays{game_id: "42", player_id: "Mandor", shape: "rock"})
    assert_receive_event(Chifoumi.Application, Chifoumi.RoundEnded, fn (event) -> assert event.winner_id == "Corwin" end)

    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerPlays{game_id: "42", player_id: "Corwin", shape: "paper"})
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerPlays{game_id: "42", player_id: "Mandor", shape: "rock"})

    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerPlays{game_id: "42", player_id: "Corwin", shape: "rock"})
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerPlays{game_id: "42", player_id: "Mandor", shape: "paper"})
    assert_receive_event(Chifoumi.Application, Chifoumi.RoundEnded, fn (event) -> event.winner_id == "Mandor" end, fn (event) -> assert event.winner_id == "Mandor" end)

    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerPlays{game_id: "42", player_id: "Corwin", shape: "paper"})
    :ok = Chifoumi.Application.dispatch(%Chifoumi.PlayerPlays{game_id: "42", player_id: "Mandor", shape: "rock"})
    assert_receive_event(Chifoumi.Application, Chifoumi.GameEnded, fn (event) -> assert event.winner_id == "Corwin" end)

    {:error, :game_is_finished} = Chifoumi.Application.dispatch(%Chifoumi.PlayerPlays{game_id: "42", player_id: "Corwin", shape: "paper"})
  end


  def game_state(game_id) do
    Commanded.Aggregates.Aggregate.aggregate_state(Chifoumi.Application, Chifoumi.Game, game_id)
  end
end
