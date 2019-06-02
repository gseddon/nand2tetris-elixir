defmodule Jack.Analyser do
  @moduledoc """
  My job is to hold state.
  1. Create a JackTokenizer from the Xxx.jack input file.
  2. Create an output file called Xxx.xml and prepare it for writing.
  3. Use the CompilationEngine to compile the input JackTokenizer into the output
  file.
  """
  alias Jack.{Tokeniser, FileLoader, Engine}

  def analyse(file) do
    {file_name, lines} = FileLoader.load_file(file)
    IO.puts(file_name)
    tokens = Tokeniser.process(lines)
    # IO.inspect(tokens, limit: :infinity, width: 120)
    {[], program} = Engine.compile(tokens, [])
    IO.inspect(Enum.reverse(program), limit: :infinity, width: 140)
  end
end
