defmodule TTFMetrics.Table.Hhea do
  def parse(
        <<version::size(32), ascent::integer-signed-16, descent::integer-signed-16,
          line_gap::integer-signed-16, advance_width_max::integer-signed-16,
          min_left_side_bearing::integer-signed-16, min_right_side_bearing::integer-signed-16,
          x_max_extent::integer-signed-16, carot_slope_rise::integer-signed-16,
          carot_slope_run::integer-signed-16, caret_offset::integer-signed-16, _::size(64),
          metric_data_format::integer-signed-16, number_of_metrics::size(16), _::binary>>
      ) do
    %{
      version: version,
      ascent: ascent,
      descent: descent,
      line_gap: line_gap,
      advance_width_max: advance_width_max,
      min_left_side_bearing: min_left_side_bearing,
      min_right_side_bearing: min_right_side_bearing,
      x_max_extent: x_max_extent,
      carot_slope_rise: carot_slope_rise,
      carot_slope_run: carot_slope_run,
      caret_offset: caret_offset,
      metric_data_format: metric_data_format,
      number_of_metrics: number_of_metrics
    }
  end
end
