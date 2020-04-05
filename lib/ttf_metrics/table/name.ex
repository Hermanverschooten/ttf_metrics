defmodule TTFMetrics.Table.Name do
  def parse(<<_::size(16), count::size(16), string_offset::size(16), data::binary>>) do
    entries =
      Enum.reduce(0..(count - 1), %{}, fn id, acc ->
        entry = parse_entry(String.slice(data, id * 12, 12))

        case entry.language_id do
          0 -> Map.put(acc, entry.name_id, entry)
          _ -> acc
        end
      end)

    %{
      copyright: 0,
      font_family: 1,
      font_subfamily: 2,
      unique_subfamily: 3,
      font_name: 4,
      version: 5,
      trademark: 7,
      manufacturer: 8,
      designer: 9,
      description: 10,
      vendor_url: 11,
      designer_url: 12,
      license: 13,
      license_url: 14,
      preferred_family: 16,
      preferred_subfamily: 17,
      compatible_full: 18,
      sample_text: 19
    }
    |> Enum.reduce(%{}, fn {key, id}, acc ->
      Map.put(acc, key, get_name(data, string_offset, entries[id]))
    end)
  end

  defp get_name(_data, _string_offset, nil), do: ""

  defp get_name(data, string_offset, entry) do
    String.slice(data, string_offset + entry.offset - 6, entry.length)
    # |> String.split("\n")
  end

  defp parse_entry(
         <<platform_id::size(16), encoding_id::size(16), language_id::size(16), name_id::size(16),
           len::size(16), offset::size(16), _::binary>>
       ) do
    %{
      platform_id: platform_id,
      encoding_id: encoding_id,
      language_id: language_id,
      name_id: name_id,
      length: len,
      offset: offset
    }
  end
end
