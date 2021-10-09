defmodule Hangmean.Word do
  use GenServer

  def start_link(_default, opts \\ %{}) do
    GenServer.start_link(Hangmean.Word, opts, name: Hangmean.Word)
  end

  def initial_state(override \\ %{}) do
    answer = override[:answer] || random_word()

    %{
      guesses: [],
      revealed_answer: String.replace(answer, ~r/\w/, "_"),
      answer: answer
    }
  end

  @impl true
  def init(opts \\ %{}) do
    {:ok, initial_state(opts)}
  end

  @impl true
  def handle_cast({:guess, letter}, state) do
    if String.contains?(state.answer, letter) do
      revealed_answer = state.revealed_answer |> String.split("", trim: true)
      answer = state.answer |> String.split("", trim: true)

      revealed_answer =
        Enum.zip(answer, revealed_answer)
        |> Enum.reduce("", fn
          {^letter, _}, acc -> acc <> letter
          {_, ra}, acc -> acc <> ra
        end)

      {:noreply, %{state | revealed_answer: revealed_answer}}
    else
      {:noreply, %{state | guesses: [letter | state.guesses] |> Enum.uniq()}}
    end
  end

  def guess(letter) do
    GenServer.cast(Hangmean.Word, {:guess, letter})
  end

  def random_word do
    Enum.random(["example", "test"])
  end
end
