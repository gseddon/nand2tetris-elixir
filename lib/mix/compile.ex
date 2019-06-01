defmodule Mix.Tasks.JackCompiler do
  use Mix.Task

  def run(_args = [h | _]) do
    Application.ensure_all_started(:jacklexer)
    Jack.Analyser.analyse(h)
  end
end
