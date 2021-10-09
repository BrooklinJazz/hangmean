defmodule Hangmean.WordTest do
  use ExUnit.Case, async: true
  doctest Hangmean.Word
  alias Hangmean.Word

  describe "Hangmean.Word" do
    test "start" do
      assert {:ok, _pid} = Word.start_link(Word, %{answer: "test"})

      assert %{revealed_answer: "____", answer: "test", guesses: []} = :sys.get_state(Word)
    end

    test "correct guess" do
      {:ok, _pid} = Word.start_link(Word, %{answer: "test"})
      Word.guess("t")

      assert %{revealed_answer: "t__t", answer: "test", guesses: []} = :sys.get_state(Word)
    end

    test "incorrect guess" do
      {:ok, _pid} = Word.start_link(Word, %{answer: "test"})
      Word.guess("a")

      assert %{revealed_answer: "____", answer: "test", guesses: ["a"]} = :sys.get_state(Word)
    end

    test "duplicate incorrect guess" do
      {:ok, _pid} = Word.start_link(Word, %{answer: "test"})
      Word.guess("a")
      Word.guess("a")

      assert %{revealed_answer: "____", answer: "test", guesses: ["a"]} = :sys.get_state(Word)
    end
  end
end
