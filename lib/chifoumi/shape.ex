defmodule Chifoumi.Shape do
  def winner("rock", "scissors"), do: "rock"
  def winner("rock", "paper"), do: "paper"
  def winner("scissors", "rock"), do: "rock"
  def winner("scissors", "paper"), do: "scissors"
  def winner("paper", "rock"), do: "paper"
  def winner("paper", "scissors"), do: "scissors"
  def winner(_shape, _other_shape), do: nil
end
