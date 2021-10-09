defmodule Hangmean.DrawTest do
  use ExUnit.Case
  doctest Hangmean.Draw
  alias Hangmean.Draw

  describe "Draw" do
    test "start" do
      assert {:ok, _pid} = Draw.start_link([])

      assert %{
               hangman: "
|----|  \n
|       \n
|       \n
|_      \n"
             } = :sys.get_state(Draw)
    end

    test "hangman" do
      assert {:ok, _pid} = Draw.start_link([])

      assert "
|----|  \n
|       \n
|       \n
|_      \n" == Draw.hangman(0)
      assert "
|----|  \n
|    0  \n
|       \n
|_      \n" == Draw.hangman(1)
      assert "
|----|  \n
|    0  \n
|   /|\\  \n
|_  | | \n" == Draw.hangman(6)
      assert "
|----|  \n
|    0  \n
|   /|\\  \n
|_  | | \n" == Draw.hangman(9999)
    end

    test "guesses" do
      assert {:ok, _pid} = Draw.start_link([])

      assert "Incorrect Guesses: abc\n" = Draw.guesses(["a", "b", "c"])
    end

    test "revealed_answer no spaces" do
      assert {:ok, _pid} = Draw.start_link([])

      assert "t _ _ t\n" = Draw.revealed_answer("t__t")
    end
  end

  #   test "last step" do
  #     assert {:ok, _pid} = Draw.start_link(Draw)

  #     assert %{
  #       hangman: "
  #        0 \n
  #       /|\
  #       | |
  #       "
  #     } = :sys.get_state(Word)
  #   end
  # end
end
