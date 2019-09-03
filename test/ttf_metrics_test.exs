defmodule TTFMetricsTest do
  use ExUnit.Case
  doctest TTFMetrics

  setup do
    {:ok, font1} = TTFMetrics.parse("test/fonts/DejaVuSans.ttf")
    {:ok, font2} = TTFMetrics.parse("test/fonts/ColorTestSbix.ttf")

    {:ok, font1: font1, font2: font2}
  end

  test "returns a %TTFMetrics{}", %{font1: font} do
    assert %TTFMetrics{} = font
  end

  test "has an ascent", %{font1: font1, font2: font2} do
    assert font1.ascent == 1556
    assert font2.ascent == 220
  end

  test "has a descent", %{font1: font1, font2: font2} do
    assert font1.descent == -492
    assert font2.descent == -80
  end

  test "has a line_gap", %{font1: font1, font2: font2} do
    assert font1.line_gap == 410
    assert font2.line_gap == 0
  end
end
