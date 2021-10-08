defmodule Game do
  use GenServer
  @max_attempts 7
  # Callbacks
  def start_link(_default) do
    GenServer.start_link(Game, [], name: Game)
  end

  def initial_state do
    word = random_word() |> String.split("", trim: true)

    %{
      guessed_letters: [],
      revealed_answer: Enum.map(word, fn l -> if l == " ", do: " ", else: "_" end),
      answer: word
    }
  end

  @impl true
  def init([]) do
    {:ok, initial_state()}
  end

  def print_revealed_answer(revealed_answer) do
    revealed_answer |> Enum.join(" ") |> IO.puts()
  end

  def print_guessed_letters(letters) do
    letters = letters |> Enum.join(" ")

    ("guesses: " <> letters) |> IO.puts()
  end

  @impl true
  def handle_cast({:guess, letter}, state) do
    if Enum.member?(state.answer, letter) do
      revealed_answer =
        Enum.zip(state.answer, state.revealed_answer)
        |> Enum.map(fn {a, ra} ->
          if a == letter, do: a, else: ra
        end)

      {:noreply, %{state | revealed_answer: revealed_answer}, {:continue, :check_win}}
    else
      {:noreply, %{state | guessed_letters: [letter | state.guessed_letters]},
       {:continue, :check_loss}}
    end
  end

  @impl true
  def handle_continue(:check_win, state) do
    if state.answer == state.revealed_answer do
      IO.puts("HOLY COW, YOU WON!")
      {:noreply, initial_state()}
    else
      {:noreply, state}
    end
  end

  def handle_continue(:check_loss, state) do
    if length(state.guessed_letters) >= @max_attempts do
      IO.puts("YOU LOSE")
      {:noreply, initial_state()}
    else
      {:noreply, state}
    end
  end

  @impl true
  def handle_call(:prompt, _from, state) do
    print_revealed_answer(state.revealed_answer)
    print_guessed_letters(state.guessed_letters)
    text = IO.gets("Guess a letter\n")
    {:reply, text, state}
  end

  def guess(letter) do
    GenServer.cast(Game, {:guess, letter})
  end

  def prompt do
    try do
      GenServer.call(Game, :prompt, 10000)
    catch
      :exit, _ ->
        prompt()
    end
  end

  def random_word do
    Enum.random(["example", "test"])
  end
end
