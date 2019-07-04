defmodule TTFMetrics do
  @moduledoc """
  Generate metrics of a given font.

  This is based on the Ruby TTFunk gem.
  """

  alias TTFMetrics.Directory
  defstruct [:ascent]

  @doc """
  parse/1

  ## Examples

      iex> TTFMetrics.parse("test/fonts/DejaVuSans.ttf")
      {:ok, %TTFMetrics{}}

  """
  def parse(font_file) do
    contents = File.read!(font_file)

    IO.inspect(Directory.parse(contents))

    {:ok, %TTFMetrics{}}
  end
end
