defmodule TTFMetrics.Directory do
  def parse(data, _offset \\ 0) do
    <<scaler_type::size(32), table_count::size(16), _::size(48), rest::binary>> = data

    %{
      scaler_type: scaler_type,
      tables: read_table_entries(table_count, rest)
    }
  end

  defp read_table_entries(count, data, t \\ %{})

  defp read_table_entries(0, _, t), do: t

  defp read_table_entries(count, data, t) do
    {rest, table} = read_table_entry(data)
    read_table_entries(count - 1, rest, Map.put(t, table.tag, table))
  end

  defp read_table_entry(
         <<tag::binary-size(4), checksum::size(32), offset::size(32), length::size(32),
           rest::binary>>
       ) do
    {rest,
     %{
       tag: tag,
       checksum: checksum,
       offset: offset,
       length: length
     }}
  end
end
