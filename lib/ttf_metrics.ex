defmodule TTFMetrics do
  @moduledoc """
  Generate metrics of a given font.

  This is based on the Ruby TTFunk gem.
  """

  defstruct [:ascent]

  @doc """
  parse/1

  ## Examples

      iex> TTFMetrics.parse("font_file")
      {:ok, %TTFMetrics{}}

  """
  def parse(font_file) do
    contents = File.read(font_file)
    {:ok, %TTFMetrics{}}
  end
end
