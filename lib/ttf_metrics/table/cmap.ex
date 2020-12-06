defmodule TTFMetrics.Table.Cmap do
  require Bitwise

  def parse(<<_version::size(16), tables::size(16), data::binary>>) do
    Enum.reduce((tables - 1)..0, [], fn id, acc ->
      <<platform_id::size(16), encoding_id::size(16), offset::size(32)>> =
        String.slice(data, id * 8, 8)

      offset = offset - 4

      <<_::binary-size(offset), content::binary>> = data

      cmap = sub_cmap(content)

      cmap =
        cmap
        |> Map.put(
          :unicode,
          (platform_id == 3 && (encoding_id == 1 || encoding_id == 10) && cmap.format != 0) ||
            (platform_id == 0 && cmap.format != 0)
        )

      [cmap | acc]
    end)
  end

  defp sub_cmap(<<0::size(16), data::binary>>) do
    <<_::size(16), language::size(16), code_map::binary-size(256), _::binary>> = data

    %{
      format: 0,
      language: language,
      code_map: for(<<x::size(16) <- code_map>>, do: x)
    }
  end

  defp sub_cmap(
         <<4::size(16), length::size(16), language::size(16), segcountx2::size(16), _::size(48),
           data::binary>>
       ) do
    <<end_code::binary-size(segcountx2), _::size(16), start_code::binary-size(segcountx2),
      id_delta::binary-size(segcountx2), id_range_offset::binary-size(segcountx2),
      rest::binary>> = data

    # Count everything we have used, up to now

    glyph_offset = 2 + 4 * segcountx2
    glyph_length = 16 + 4 * segcountx2
    length = length - glyph_length

    <<_::binary-size(glyph_offset), glyph_ids::binary-size(length), _::binary>> = data

    glyph_ids = for(<<x::16 <- glyph_ids>>, do: x)

    segcount = div(segcountx2, 2)

    end_code = for(<<x::size(16) <- end_code>>, do: x)
    start_code = for(<<x::size(16) <- start_code>>, do: x)
    id_delta = for(<<x::16-signed-integer <- id_delta>>, do: x)
    id_range_offset = for(<<x::16 <- id_range_offset>>, do: x)

    code_map =
      Enum.reduce(Enum.with_index(end_code), %{}, fn {tail, i}, acc ->
        Enum.reduce(Enum.at(start_code, i)..tail, acc, fn code, iacc ->
          glyph_id =
            if Enum.at(id_range_offset, i) == 0 do
              code + Enum.at(id_delta, i)
            else
              index =
                div(Enum.at(id_range_offset, i), 2) +
                  (code - Enum.at(start_code, i)) - (segcount - 1)

              case Enum.at(glyph_ids, index, 0) do
                0 -> 0
                n -> n + Enum.at(id_delta, i)
              end
            end

          Map.put(iacc, code, Bitwise.band(glyph_id, 0xFFFF))
        end)
      end)

    %{
      format: 4,
      language: language,
      code_map: code_map
    }

    # |> IO.inspect(limit: :infinity)
  end

  defp sub_cmap(
         <<6::size(16), _::size(16), language::size(16), firstcode::size(16),
           entrycount::size(16), data::binary>>
       ) do
    code_map =
      Enum.reduce(0..(entrycount - 1), %{}, fn code, acc ->
        offset = code * 2
        <<_::binary-size(offset), x::size(16), _::binary>> = data
        Map.put(acc, code + firstcode, Bitwise.band(x, 0xFFFF))
      end)

    %{format: 6, language: language, code_map: code_map}
  end

  defp sub_cmap(
         <<10::size(16), 0::size(16), _::size(64), language::size(32), firstcode::size(32),
           entrycount::size(32), data::binary>>
       ) do
    code_map =
      Enum.reduce(0..(entrycount - 1), %{}, fn code, acc ->
        offset = code * 2
        <<_::binary-size(offset), x::size(16), _::binary>> = data
        Map.put(acc, code + firstcode, Bitwise.band(x, 0xFFFF))
      end)

    %{format: 10, language: language, code_map: code_map}
  end

  defp sub_cmap(
         <<12::size(16), 0::size(16), _::size(32), language::size(32), groupcount::size(32),
           data::binary>>
       ) do
    code_map =
      Enum.reduce(1..groupcount, %{}, fn index, acc ->
        skip = 12 * (index - 1)

        <<_::binary-size(skip), startchar::size(32), endchar::size(32), startglyph::size(32),
          _::binary>> = data

        Enum.reduce(0..(endchar - startchar), acc, fn offset, iacc ->
          Map.put(iacc, startchar + offset, startglyph + offset)
        end)
      end)

    %{format: 12, language: language, code_map: code_map}
  end
end
