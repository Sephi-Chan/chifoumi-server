defmodule Chifoumi.GameLifespan do
  @behaviour Commanded.Aggregates.AggregateLifespan

  def after_event(%Chifoumi.GameCancelled{}), do: :stop
  def after_event(%Chifoumi.GameEnded{}), do: :stop
  def after_event(_event), do: :timer.hours(24)

  def after_command(_command), do: :timer.hours(24)

  def after_error(_error), do: :stop
end
