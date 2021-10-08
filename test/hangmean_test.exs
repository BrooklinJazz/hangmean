defmodule HangmeanTest do
  use ExUnit.Case, async: true
  doctest Hangmean

  test "greets the world" do
    Hangman.start()
  end
end
