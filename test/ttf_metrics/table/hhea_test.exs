defmodule TTFMetrics.Table.HheaTest do
  use ExUnit.Case

  alias TTFMetrics.Table.Hhea

  test "parse version 0" do
    data =
      <<0, 1, 0, 0, 7, 109, 254, 29, 0, 0, 13, 226, 247, 214, 250, 81, 13, 114, 0, 1, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 23, 40>>

    hhea = Hhea.parse(data)

    assert hhea == %{
             version: 65536,
             ascent: 1901,
             descent: -483,
             line_gap: 0,
             advance_width_max: 3554,
             min_left_side_bearing: -2090,
             min_right_side_bearing: -1455,
             x_max_extent: 3442,
             carot_slope_rise: 1,
             carot_slope_run: 0,
             caret_offset: 0,
             metric_data_format: 0,
             number_of_metrics: 5928
           }
  end
end
