# Jacklexer

This will parse a file in the Jack language, as specified into the Nand2Tetris course.
Currently the output format is an XML syntax tree, marked up with the syntax type.
If you run it with the included `test.sh` script, it will automatically compare the XML
output with the Nand2Tetris solutions. This script also works in git bash on windows.

e.g.

```
> ./test.sh "C:\\Users\\d883693\\git\\nand2tetris\\projects\\10\\ArrayTest\\Main.jack"
Main
Compile complete.
Comparison ended successfully
```

# Comments
Calling the script with the `-x` parameter will result in the abstract syntax tree being
printed to screen in a beautiful custom elixir format, with comments from the source code
included in the right locations. This can be useful for debugging.

## Monkeypatching
In the XML lib, in `xml_builder.ex`, replace line 216 with:
```elixir
    do: [indent(level, options), '<', to_string(name), '>', '\n', indent(level, options), '</', to_string(name), '>']
```
This is necessary because the included nand2tetris solution XML files do not use self closing tags.

