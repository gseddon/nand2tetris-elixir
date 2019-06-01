defmodule Token do
  alias Jack.Tokeniser
  defstruct [:type, :value, :line]

  @type t :: %__MODULE__{
    type: Tokeniser.token_type_t(),
    value: String.t() | number | Tokeniser.keyword_t(),
    line: non_neg_integer
  }
end

defmodule Jack.Tokeniser do
  @moduledoc """
  Given a sequence of lines as input, split them up into tokens.
  """

  @type keyword_t :: :class  | :method  | :function  | :constructor  |
   :int  | :boolean | :char  | :void  | :var |  :static  | :field  |
   :let  | :do  | :if  | :else  | :while  | :return  | :true  | :false  | :null  | :this

  @type token_type_t :: :keyword | :symbol | :identifier | :int_const | :string_const | :comment

  @doc """
  Given a number of lines representing an entire file, return them as tokens.
  """
  def process(lines) do
    lines
    |> Enum.with_index(1)
    |> Enum.map(&tokenise/1)
    |> List.flatten()
  end

  @doc """
  Given a specific line, return a list of the tokens that compose that line.
  """
  def tokenise({{:comment, line}, lineno}) do
    %Token{type: :comment, value: line, line: lineno}
  end

  def tokenise({{:nocomment, [line, inline_comment]}, lineno}) do
    [tokenise({{:nocomment, line}, lineno}), %Token{type: :comment, value: inline_comment, line: lineno}]
  end

  def tokenise({{:nocomment, line}, lineno}) do
    Regex.split(~r/\".*\"/U, line, include_captures: true) # Split out quoted strings
    |> Enum.map(fn
       "\"" <> _rest = line -> # Don't split quoted strings further
          line

       line ->
          Regex.split(~r{\W}, line, trim: true, include_captures: true)
          |> Enum.reject(fn el -> el == " " end)
       end )
    |> List.flatten()
    |> Enum.map( fn el ->
      with type <- token_type(el) do
        case type do
          :keyword ->
            %Token{type: :keyword, value: el |> String.to_atom(), line: lineno}
          _ ->
            %Token{type: type, value: el, line: lineno}
        end
      end
    end)
  end


  @doc """
  one of KEYWORD, SYMBOL, IDENTIFIER, INT_CONST, STRING_CONST
  """
  @spec token_type(any) :: token_type_t
  def token_type(var) do
    case var do
      var when var in ["class", "constructor", "function", "method", "field", "static", "var",
          "int", "char", "boolean", "void", "true", "false", "null", "this", "let", "do",
          "if", "else", "while", "return"] ->
            :keyword
      symbol when symbol in ["{", "}", "(", ")", "[", "]", ".",
          ",", ";", "+", "-", "*", "/", "&", "|", "<", ">", "=", "~"] ->
            :symbol
      "\"" <> _ ->
         :string_const
      var ->
        case Integer.parse(var) do
          :error -> :identifier
          _ -> :int_const
        end
    end
  end
end
