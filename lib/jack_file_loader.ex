defmodule Jack.FileLoader do

  def load_file(path) do
    {:ok, file} = File.open(path, [:read, :utf8] )
    file_name = extract_jack_filename(path)

    lines =
      file
      |> IO.stream(:line)
      |> filter_multiline_comments()
    {file_name, lines}
  end

  def write_file(contents, file_path) do
    {:ok, file} =
      file_path
      |> generate_output_filename()
      |> File.open([:write, :utf8])

    IO.write(file, contents)
  end

  def generate_output_filename({type, path}) do
    case type do
      :folder ->
        Path.join([
          path,
          Path.basename(path) <> ".xml"
        ])
      :xml ->
        Path.join([
          Path.dirname(path),
          Path.basename(path, ".jack") <> "_out.xml"
        ])
    end
  end

  @doc """
  This only handles multiline comments. // comments are still passed through.
  """
  def filter_multiline_comments(lines) do
    lines
    |> Enum.reduce({:nocomment, []}, fn line, {status, acc} ->
      line = String.trim(line)
        cond do
          String.contains?(line, "*/") ->
            {:nocomment, acc ++ [comment: line]}

          String.starts_with?(line, "/*") ->
            {:comment, acc ++ [comment: line]}

          String.starts_with?(line, "//") ->
            {:nocomment, acc ++ [comment: line]}

          status == :comment ->
            {:comment, acc ++ [comment: line]}

          String.contains?(line, "//") -> # String has an inline comment. Stripping for now.
            {:nocomment, acc ++ [nocomment: String.split(line, "//")]}

          true ->
            {:nocomment, acc ++ [nocomment: line]}
        end
    end )
    |> (fn {_state, lines} -> lines end).()
  end

  defp extract_jack_filename(file_path), do: Path.basename(file_path, ".jack")


  # defp is_jack_dir?(file_path) do
  #   extract_vm_filename(file_path) == Path.basename(file_path)
  # end
end
