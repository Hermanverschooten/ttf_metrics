defmodule TTFMetrics.Table.CMapTest do
  use ExUnit.Case

  @data File.read!("test/data/cmap.data")

  test "cmap" do
    assert %{
             version: 0,
             tables: [
               %{encoding_id: 3, platform_id: 0, format: 4, language: 0}
             ]
           } = cmap = TTFMetrics.Table.CMap.parse(@data)

    [table | _] = cmap.tables
    assert table.code_map[0] == 0
    assert table.code_map[32] == 3
    assert table.code_map[65533] == 5182
    assert table.code_map[65535] == 0
  end
end
