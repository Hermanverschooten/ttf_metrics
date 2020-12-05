defmodule TTFMetrics.Table.CMap do
  def parse(<<version::size(16), table_count::size(16), tables::binary>>) do
    {tables, _} = Enum.reduce(1..1, {[], tables}, &parse_table/2)

    %{
      version: version,
      tables: tables |> Enum.reverse()
    }
  end

  defp parse_table(
         _id,
         {acc, <<platform_id::size(16), encoding_id::size(16), offset::size(32), rest::binary>>}
       ) do
    offset = offset - 12

    <<_::binary-size(offset), data::binary>> = rest

    {table, rest} = parse_data(data)

    {[
       %{
         platform_id: platform_id,
         encoding_id: encoding_id,
         format: table.format,
         language: table.language,
         code_map: table.code_map
       }
       | acc
     ], rest}
  end

  defp parse_data(
         <<format::size(16), _::size(16), language::size(16), code_map::binary-size(256),
           rest::binary>>
       )
       when format == 0 do
    {%{
       format: format,
       language: language,
       code_map: code_map
     }, rest}
  end

  defp parse_data(
         <<format::size(16), length::size(16), language::size(16), seg_countx2::size(16),
           _::binary-size(6), rest::binary>>
       )
       when format == 4 do
    <<data::binary-size(length), rest::binary>> = rest

    seg_count = seg_countx2 / 2

    glyphlength = length - seg_countx2 * 4 - 16

    <<
      end_code::binary-size(seg_countx2),
      _::size(16),
      start_code::binary-size(seg_countx2),
      id_delta_unsigned::binary-size(seg_countx2),
      id_range_offset::binary-size(seg_countx2),
      glyph::binary-size(glyphlength),
      _::binary
    >> = data

    end_code = to_int(end_code)

    start_code = to_int(start_code)

    id_delta = to_signed_int(id_delta_unsigned)

    id_range_offset = to_int(id_range_offset)

    glyph = to_int(glyph)

    code_map =
      end_code
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {tail, i}, acc ->
        Enum.at(start_code, i)..tail
        |> Enum.reduce(acc, fn code, acc ->
          glyph_id =
            if Enum.at(id_range_offset, i) == 0 do
              code + Enum.at(id_delta, i)
            else
              index =
                div(Enum.at(id_range_offset, i), 2) + (code - Enum.at(start_code, i)) -
                  (seg_count - i)

              glyph_id = Enum.at(glyph, index, 0)
              if glyph_id == 0, do: glyph_id, else: glyph_id + Enum.at(id_delta, i)
            end

          Map.put(acc, code, Bitwise.band(glyph_id, 0xFFFF))
        end)
      end)

    {%{
       format: format,
       language: language,
       code_map: code_map
     }, rest}
  end

  defp to_int(list) do
    list
    |> String.codepoints()
    |> Enum.chunk_every(2)
    |> Enum.map(fn [<<a>>, <<b>>] ->
      <<c::16>> = <<a, b>>
      c
    end)
  end

  defp to_signed_int(list) do
    list
    |> String.codepoints()
    |> Enum.chunk_every(2)
    |> Enum.map(fn [<<a>>, <<b>>] ->
      <<c::16>> = <<a, b>>
      # number >= 0x8000 ? -((number ^ 0xFFFF) + 1) : number

      if c > 0x8000, do: -(Bitwise.bxor(c, 0xFFFF) + 1), else: c
    end)
  end
end
