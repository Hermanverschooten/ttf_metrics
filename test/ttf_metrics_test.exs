defmodule TTFMetricsTest do
  use ExUnit.Case
  doctest TTFMetrics

  test "returns a %TTFMetrics{}" do
    assert {:ok, %TTFMetrics{}} == TTFMetrics.parse("test/fonts/DejaVuSans.ttf")
  end
end
