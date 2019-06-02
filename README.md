# Jacklexer

## Monkeypatching
In the XML lib, in `xml_builder.ex`, replace line 216 with:
```elixir
    do: [indent(level, options), '<', to_string(name), '>', '\n', indent(level, options), '</', to_string(name), '>']
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `jacklexer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:jacklexer, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/jacklexer](https://hexdocs.pm/jacklexer).

