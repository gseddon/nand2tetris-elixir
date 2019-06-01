defmodule Jack.FileLoader do

  def load_file(path) do
    {:ok, file} = File.open(path, [:read, :utf8] )
    file_name = extract_jack_filename(path)

    lines = Enum.flat_map(IO.stream(file, :line), &clean_line/1)
    {file_name, lines}
  end

  # defp clean_line_comments(line) do
  #   [code | comment] = line
  #   |> String.split("//")

  #   comment = with [com | _] <- comment, do: ["//" <> com |> String.trim()]

  #   comment ++
  #   (code
  #   |> String.trim()
  #   |> (fn
  #         "" -> []
  #         command -> [command]
  #       end).())
  # end

 defp clean_line(line) do
   line
   |> String.split("//")
   |> hd()
   |> String.trim()
   |> (fn
         "" -> []
         command -> [command]
       end).()
 end

  defp extract_jack_filename(file_path), do: Path.basename(file_path, ".jack")


  # defp is_jack_dir?(file_path) do
  #   extract_vm_filename(file_path) == Path.basename(file_path)
  # end
end
