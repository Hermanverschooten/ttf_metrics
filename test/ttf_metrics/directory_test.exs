defmodule TTFMetrics.DirectoryTest do
  use ExUnit.Case

  alias TTFMetrics.Directory

  setup do
    directory =
      File.read!("test/fonts/DejaVuSans.ttf")
      |> Directory.parse()

    %{directory: directory}
  end

  test "scaler_type", %{directory: directory} do
    assert directory.scaler_type == 65536
  end

  test "number of tables", %{directory: directory} do
    assert length(Map.keys(directory.tables)) == 19
  end

  test "table contains FFTM", %{directory: directory} do
    assert Map.has_key?(directory.tables, "FFTM")
    fftm = Map.get(directory.tables, "FFTM")
    assert fftm.tag == "FFTM"
    assert fftm.checksum == 1_554_617_204
    assert fftm.offset == 316
    assert fftm.length == 28
  end

  test "table contains prep", %{directory: directory} do
    assert Map.has_key?(directory.tables, "prep")
    fftm = Map.get(directory.tables, "prep")
    assert fftm.tag == "prep"
    assert fftm.checksum == 990_376_192
    assert fftm.offset == 718_628
    assert fftm.length == 1384
  end
end
