defmodule TTFMetricsTest do
  use ExUnit.Case
  doctest TTFMetrics

  test "parse a font file" do
    assert {:ok, %TTFMetrics{}} == TTFMetrics.parse("test/fonts/DejaVuSans.ttf")
  end
end
