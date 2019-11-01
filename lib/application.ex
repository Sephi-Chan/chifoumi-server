require Chifoumi.Game

defmodule Chifoumi.Application do
  use Commanded.Application, otp_app: :chifoumi
  router Chifoumi.Router
end
