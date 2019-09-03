defmodule TTFMetrics.Table.OS2 do
  def parse(
        <<version::size(16), ave_char_width::integer-signed-16, weight_class::size(16),
          width_class::size(16), type::integer-signed-16, y_subscript_x_size::integer-signed-16,
          y_subscript_y_size::integer-signed-16, y_subscript_x_offset::integer-signed-16,
          y_subscript_y_offset::integer-signed-16, y_superscript_x_size::integer-signed-16,
          y_superscript_y_size::integer-signed-16, y_superscript_x_offset::integer-signed-16,
          y_superscript_y_offset::integer-signed-16, y_strikeout_size::integer-signed-16,
          y_strikeout_position::integer-signed-16, family_class::integer-signed-16,
          panose::binary-size(10), char_range::binary-size(16), vendor_id::binary-size(4),
          selection::size(16), first_char_index::size(16), last_char_index::size(16),
          rest::binary>>
      ) do
    %{
      version: version,
      ave_char_width: ave_char_width,
      weight_class: weight_class,
      width_class: width_class,
      type: type,
      y_subscript_x_size: y_subscript_x_size,
      y_subscript_y_size: y_subscript_y_size,
      y_subscript_x_offset: y_subscript_x_offset,
      y_subscript_y_offset: y_subscript_y_offset,
      y_superscript_x_size: y_superscript_x_size,
      y_superscript_y_size: y_superscript_y_size,
      y_superscript_x_offset: y_superscript_x_offset,
      y_superscript_y_offset: y_superscript_y_offset,
      y_strikeout_size: y_strikeout_size,
      y_strikeout_position: y_strikeout_position,
      family_class: family_class,
      panose: panose,
      char_range: char_range,
      vendor_id: vendor_id,
      selection: selection,
      first_char_index: first_char_index,
      last_char_index: last_char_index,
      ascent: nil,
      descent: nil,
      line_gap: nil,
      win_ascent: nil,
      win_descent: nil,
      code_page_range: nil,
      x_height: nil,
      cap_height: nil,
      default_char: nil,
      break_char: nil,
      max_context: nil
    }
    |> parse_version_1(version, rest)
  end

  def parse_version_1(
        table,
        version,
        <<ascent::integer-signed-16, descent::integer-signed-16, line_gap::integer-signed-16,
          win_ascent::size(16), win_descent::size(16), code_page_range::binary-size(8),
          rest::binary>>
      )
      when version > 0 do
    %{
      table
      | ascent: ascent,
        descent: descent,
        line_gap: line_gap,
        win_ascent: win_ascent,
        win_descent: win_descent,
        code_page_range: code_page_range
    }
    |> parse_higher_version(version, rest)
  end

  def parse_version_1(table, _, _), do: table

  def parse_higher_version(
        table,
        version,
        <<x_height::integer-signed-16, cap_height::integer-signed-16, default_char::size(16),
          break_char::size(16), max_context::size(16), _::binary>>
      )
      when version > 1 do
    %{
      table
      | x_height: x_height,
        cap_height: cap_height,
        default_char: default_char,
        break_char: break_char,
        max_context: max_context
    }
  end

  def parse_higher_version(table, _, _), do: table
end
