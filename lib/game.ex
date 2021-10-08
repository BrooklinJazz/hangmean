defmodule Game do
  use GenServer

  # Callbacks
  def start_link(_default) do
    GenServer.start_link(Game, [], name: Game)
  end

  @impl true
  def init([]) do
    initial_state = %{guesses: [], answer: random_word()}
    {:ok, initial_state}
  end

  def random_word do
    "test"
  end

  @impl true
  def handle_call({:guess, guess}, from, state) do
    {:reply, guess == state.answer, state}
  end

  def guess(text) do
    GenServer.call(Game, {:guess, text})
  end

  # @impl true
  # def handle_cast({:push, element}, state) do
  #   {:noreply, [element | state]}
  # end
end
