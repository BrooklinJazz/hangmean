defmodule Hangmean do
  # use Application
  alias Hangmean.Draw
  alias Hangmean.Word

  # @impl true
  def start() do
    children = [
      Word,
      Draw
    ]

    Supervisor.start_link(children, strategy: :one_for_all)
    play()
    {:ok, self()}
  end

  defp play do
    IEx.Helpers.clear()
    %{guesses: guesses, revealed_answer: revealed_answer} = :sys.get_state(Word)
    IO.write(Draw.hangman(length(guesses)))
    IO.write(Draw.revealed_answer(revealed_answer))
    IO.write(Draw.guesses(guesses))
    guess = IO.gets("\nWhat's your guess?\n") |> String.trim() |> String.first()
    Word.guess(guess)
    play()
  end
end
