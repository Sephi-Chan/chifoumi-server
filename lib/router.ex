defmodule Chifoumi.Router do
  use Commanded.Commands.Router, application: Chifoumi.Application

  dispatch([
    Chifoumi.PlayerCreatesGame,
    Chifoumi.PlayerJoinsGame,
    Chifoumi.PlayerLeavesGame,
    Chifoumi.PlayerPlays,
  ], to: Chifoumi.Game, identity: :game_id)
end
