defmodule Jack.Analyser do
  @moduledoc """
  My job is to hold state.
  1. Create a JackTokenizer from the Xxx.jack input file.
  2. Create an output file called Xxx.xml and prepare it for writing.
  3. Use the CompilationEngine to compile the input JackTokenizer into the output
  file.
  """
  alias Jack.{Tokeniser, FileLoader, Engine}

  def analyse(file, opts) do
    {file_name, lines} = FileLoader.load_file(file)
    IO.puts(file_name)
    tokens = Tokeniser.process(lines)

    {[], program} = Engine.compile(tokens, [])

    if opts[:only_stdout] do
      print_structs(program)
    else
      xml =
        program
        |> Enum.reverse()
        |> Enum.flat_map(&xml_clean/1)
        |> XmlBuilder.generate()

      FileLoader.write_file(xml, {:xml, file})
    end
  end

  def print_structs(program) do
    program
    |> Enum.reverse()
    |> IO.inspect(limit: :infinity, width: 140)
  end

  def xml_clean(%Tk{type: :comment}), do: []
  def xml_clean([]), do: []

  def xml_clean(%Tk{type: type, val: value}), do: [{uglify_case(type), nil, " #{value} "}]

  def xml_clean(%StEl{type: type, els: elements}), do: [{uglify_case(type), nil, elements |> Enum.flat_map(&xml_clean/1)}]

  @doc """
  takes something like :class_var_dec and turns it into classVarDec
  """
  def uglify_case(type) do
    nearly =
      type
      |> Atom.to_string()
      |> Macro.camelize()

    Regex.replace(~r/^./, nearly, &String.downcase/1)
  end

end
