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

  @type token_type_t :: :keyword | :symbol | :identifier | :int_const | :string_const


  @doc """
  Given a specific line, return a list of the tokens that compose that line.
  """
  def split(line, lineno \\ 1) do
    Regex.split(~r{\W}, line, trim: true, include_captures: true)
    |> Enum.filter(fn s -> s != " " end)
    |> tokenise(lineno)
  end

  @spec tokenise([any], non_neg_integer) :: [Token.t()]
  def tokenise([], _), do: []
  def tokenise([el | rest], lineno) do
    {more, token} =
      case token_type(el) do
      :keyword ->
         {rest, %Token{type: :keyword, value: String.to_atom(el)}}
      :int_const ->
        {rest, %Token{type: :int_const, value: (with {val, _} <- Integer.parse(el), do: val)}}
      :symbol ->
        {rest, %Token{type: :symbol, value: el}}
      :identifier ->
        {rest, %Token{type: :identifier, value: el}}
      :string_const ->
        [str, ~s<"> | more] = rest
        {more, %Token{type: :string_const, value: str}}
    end
    [%Token{token | line: lineno}] ++
    tokenise(more, lineno)
  end

  @doc """
  one of KEYWORD, SYMBOL, IDENTIFIER, INT_CONST, STRING_CONST
  """
  @spec token_type(any) :: token_type_t
  def token_type([var | _]) do
    case var do
      var when var in ["class", "constructor", "function", "method", "field", "static", "var",
          "int", "char", "boolean", "void", "true", "false", "null", "this", "let", "do",
          "if", "else", "while", "return"] ->
            :keyword
      symbol when symbol in ["{", "}", "(", ")", "[", "]", ".",
          ",", ";", "+", "-", "*", "/", "&", "|", "<", ">", "=", "~"] ->
            :symbol
      ~s<"> ->
         :string_const
      var ->
        case Integer.parse(var) do
          :error -> :identifier
          _ -> :int_const
        end
    end
  end

  @doc """
  Returns the character which is the current token.
  Should be called only when tokenType() is SYMBOL.
  """
  def symbol(token) do

  end

  @doc """
  Returns the identifier which is the current token.
  Should be called only when tokenType() is IDENTIFIER.
  """
  def identifier(token) do

  end

  @doc """
  Returns the integer value of the current token.
  Should be called only when tokenType() is INT_CONST.
  """
  def int_val(token) do

  end

  @doc """
  Returns the string value of the current token, without the double quotes.
  Should be called only when tokenType() is STRING_CONST.
  """
  def string_val(token) do

  end
end
