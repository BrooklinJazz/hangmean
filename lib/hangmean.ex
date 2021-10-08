defmodule Hangmean do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Game
    ]

    Supervisor.start_link(children, strategy: :one_for_all)
    play()
    {:ok, self()}
  end

  def play do
    text = Game.prompt() |> String.trim() |> String.first()
    Game.guess(text)
    play()
  end
end
