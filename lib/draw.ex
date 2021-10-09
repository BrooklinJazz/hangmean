defmodule Hangmean.Draw do
  use GenServer

  @hangman_steps [
    "
|----|  \n
|       \n
|       \n
|_      \n",
    "
|----|  \n
|    0  \n
|       \n
|_      \n",
    "
|----|  \n
|    0  \n
|    |  \n
|_      \n",
    "
|----|  \n
|    0  \n
|    |  \n
|_  |   \n",
    "
|----|  \n
|    0  \n
|    |  \n
|_  | | \n",
    "
|----|  \n
|    0  \n
|   /|  \n
|_  | | \n",
    "
|----|  \n
|    0  \n
|   /|\\  \n
|_  | | \n"
  ]
  def start_link(_default) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def initial_state() do
    %{
      hangman: List.first(@hangman_steps)
    }
  end

  @impl true
  def init(_opts) do
    {:ok, initial_state()}
  end

  @impl true
  def handle_call(:hangman, _from, state) do
    {:reply, state.hangman, state}
  end

  def hangman(step) do
    Enum.at(@hangman_steps, step, List.last(@hangman_steps))
  end

  def hangman do
    GenServer.call(Hangmean.Draw, :hangman)
  end

  def guesses(letters) do
    "Incorrect Guesses: #{letters}\n"
  end

  def revealed_answer(word) do
    word =
      word
      |> String.split("", trim: true)
      |> Enum.reduce(fn
        char, nil -> char
        char, acc -> acc <> " " <> char
      end)

    word <> "\n"
  end
end
