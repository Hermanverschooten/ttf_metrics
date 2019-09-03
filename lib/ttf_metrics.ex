defmodule TTFMetrics do
  @moduledoc """
  Generate metrics of a given font.

  This is based on the Ruby TTFunk gem.
  """

  alias TTFMetrics.Directory
  alias TTFMetrics.Table
  defstruct [:ascent, :descent, :line_gap]

  @spec parse(String.t()) :: {:ok, TTFMetrics.t()}
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

    {:ok,
     %TTFMetrics{
       ascent: ascent(tables),
       descent: descent(tables),
       line_gap: line_gap(tables)
     }}
  end

  defp parse_table("OS/2", data) do
    Table.OS2.parse(data)
  end

  defp parse_table("hhea", data) do
    Table.Hhea.parse(data)
  end

  defp parse_table(_, _), do: %{}

  defp ascent(%{"OS/2" => os2, "hhea" => hhea}) do
    if os2.ascent != 0 do
      os2.ascent
    else
      hhea.ascent
    end
  end

  defp ascent(_), do: nil

  defp descent(%{"OS/2" => os2, "hhea" => hhea}) do
    if os2.descent != 0 do
      os2.descent
    else
      hhea.descent
    end
  end

  defp descent(_), do: nil

  defp line_gap(%{"OS/2" => os2, "hhea" => hhea}) do
    if os2.line_gap != 0 do
      os2.line_gap
    else
      hhea.line_gap
    end
  end

  defp line_gap(_), do: nil
end
