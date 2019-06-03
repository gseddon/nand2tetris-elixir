defmodule Mix.Tasks.JackCompiler do
  use Mix.Task

  def run(args = [h | _]) do
    only_stdout = "-x" in args
    opts = [only_stdout: only_stdout]
    Application.ensure_all_started(:jacklexer)
    Jack.Analyser.analyse(h, opts)
  end
end
