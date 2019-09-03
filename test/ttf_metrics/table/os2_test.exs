defmodule TTFMetrics.Table.OS2Test do
  use ExUnit.Case

  alias TTFMetrics.Table.OS2

  test "parse version 0" do
    data =
      <<0, 0, 4, 14, 1, 144, 0, 5, 0, 0, 5, 51, 5, 153, 0, 0, 1, 30, 5, 51, 5, 153, 0, 0, 3, 215,
        0, 102, 2, 18, 0, 0, 2, 11, 6, 3, 3, 8, 4, 2, 2, 4, 231, 0, 46, 255, 210, 0, 253, 255, 10,
        36, 96, 41, 0, 0, 0, 0, 80, 102, 69, 100, 0, 64, 0, 32, 255, 255>>

    os2 = OS2.parse(data)

    assert os2 == %{
             version: 0,
             ave_char_width: 1038,
             weight_class: 400,
             width_class: 5,
             type: 0,
             y_subscript_x_size: 1331,
             y_subscript_y_size: 1433,
             y_subscript_x_offset: 0,
             y_subscript_y_offset: 286,
             y_superscript_x_size: 1331,
             y_superscript_y_size: 1433,
             y_superscript_x_offset: 0,
             y_superscript_y_offset: 983,
             y_strikeout_size: 102,
             y_strikeout_position: 530,
             family_class: 0,
             panose: <<2, 11, 6, 3, 3, 8, 4, 2, 2, 4>>,
             char_range: <<0xE7, 0, 46, 0xFF, 0xD2, 0, 0xFD, 0xFF, 10, 36, 96, 41, 0, 0, 0, 0>>,
             vendor_id: "PfEd",
             selection: 64,
             first_char_index: 32,
             last_char_index: 65535,
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
  end

  test "parse version 1" do
    data =
      <<0, 1, 4, 14, 1, 144, 0, 5, 0, 0, 5, 51, 5, 153, 0, 0, 1, 30, 5, 51, 5, 153, 0, 0, 3, 215,
        0, 102, 2, 18, 0, 0, 2, 11, 6, 3, 3, 8, 4, 2, 2, 4, 231, 0, 46, 255, 210, 0, 253, 255, 10,
        36, 96, 41, 0, 0, 0, 0, 80, 102, 69, 100, 0, 64, 0, 32, 255, 255, 6, 20, 254, 20, 1, 154,
        7, 109, 1, 227, 96, 0, 1, 255, 223, 255, 0, 0>>

    os2 = OS2.parse(data)

    assert os2 == %{
             version: 1,
             ave_char_width: 1038,
             weight_class: 400,
             width_class: 5,
             type: 0,
             y_subscript_x_size: 1331,
             y_subscript_y_size: 1433,
             y_subscript_x_offset: 0,
             y_subscript_y_offset: 286,
             y_superscript_x_size: 1331,
             y_superscript_y_size: 1433,
             y_superscript_x_offset: 0,
             y_superscript_y_offset: 983,
             y_strikeout_size: 102,
             y_strikeout_position: 530,
             family_class: 0,
             panose: <<2, 11, 6, 3, 3, 8, 4, 2, 2, 4>>,
             char_range: <<0xE7, 0, 46, 0xFF, 0xD2, 0, 0xFD, 0xFF, 10, 36, 96, 41, 0, 0, 0, 0>>,
             vendor_id: "PfEd",
             selection: 64,
             first_char_index: 32,
             last_char_index: 65535,
             ascent: 1556,
             descent: -492,
             line_gap: 410,
             win_ascent: 1901,
             win_descent: 483,
             code_page_range: <<96, 0, 1, 255, 223, 255, 0, 0>>,
             x_height: nil,
             cap_height: nil,
             default_char: nil,
             break_char: nil,
             max_context: nil
           }
  end

  test "parse version > 1" do
    data =
      <<0x00, 0x04, 0x00, 0xB4, 0x01, 0x90, 0x00, 0x05, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x00, 0x4B,
        0x04, 0x07, 0x02, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x6A, 0x65,
        0x6E, 0x73, 0x00, 0x40, 0x00, 0x00, 0x00, 0x75, 0x00, 0xDC, 0xFF, 0xB0, 0x00, 0x00, 0x00,
        0xDC, 0x00, 0x50, 0x20, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x73, 0x00, 0xB4,
        0x00, 0x00, 0x00, 0x20, 0x00, 0x00>>

    os2 = OS2.parse(data)

    assert os2 == %{
             version: 4,
             ave_char_width: 180,
             weight_class: 400,
             width_class: 5,
             type: 4,
             y_subscript_x_size: 0,
             y_subscript_y_size: 0,
             y_subscript_x_offset: 0,
             y_subscript_y_offset: 0,
             y_superscript_x_size: 0,
             y_superscript_y_size: 0,
             y_superscript_x_offset: 0,
             y_superscript_y_offset: 0,
             y_strikeout_size: 15,
             y_strikeout_position: 75,
             family_class: 1031,
             panose: <<2, 6, 0, 0, 0, 0, 0, 0, 0, 0>>,
             char_range: <<0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>,
             vendor_id: "jens",
             selection: 64,
             first_char_index: 0,
             last_char_index: 117,
             ascent: 220,
             descent: -80,
             line_gap: 0,
             win_ascent: 220,
             win_descent: 80,
             code_page_range: <<32, 0, 0, 1, 0, 0, 0, 0>>,
             x_height: 115,
             cap_height: 180,
             default_char: 0,
             break_char: 32,
             max_context: 0
           }
  end
end
