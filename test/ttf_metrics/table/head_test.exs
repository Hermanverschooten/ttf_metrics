defmodule TTFMetrics.Table.HeadTest do
  use ExUnit.Case

  alias TTFMetrics.Table.Head

  @data File.read!("test/data/head.data")

  test "parse" do
    assert %{version: 655_536} = Head.parse(@data)
  end
end
