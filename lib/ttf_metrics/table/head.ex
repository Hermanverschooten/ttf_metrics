defmodule TTFMetrics.Table.Head do
  def parse(<<version::size(32), _::binary>>) do
    %{
      version: version
    }
  end
end
