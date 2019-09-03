defmodule TTFMetrics do
  @moduledoc """
  Generate metrics of a given font.

  This is based on the Ruby TTFunk gem.
  """

  alias TTFMetrics.Directory
  alias TTFMetrics.Table
  defstruct [:ascent]

  @doc """
  parse/1

  ## Examples

      iex> TTFMetrics.parse("test/fonts/DejaVuSans.ttf")
      {:ok, %TTFMetrics{}}

  """
  def parse(font_file) do
    contents = File.read!(font_file)
    directory = Directory.parse(contents)

    tables =
      Enum.reduce(directory.tables, %{}, fn {table, info}, acc ->
        offset = info.offset
        length = info.length
        <<_::binary-size(offset), part::binary-size(length), _::binary>> = contents
        Map.put(acc, table, parse_table(table, part))
      end)

    IO.inspect(tables)

    {:ok, %TTFMetrics{}}
  end

  defp parse_table("OS/2", data) do
    Table.OS2.parse(data)
  end

  defp parse_table(_, _), do: %{}
end
