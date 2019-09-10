defmodule Backex.BuildIn do
  @moduledoc false

  def replace_build_in(request, name, map) do
    collection = Map.get(request, name, [])

    collection =
      Enum.map(collection, fn {module, setting} ->
        {Map.get(map, module, module), setting}
      end)

    Map.put(request, name, collection)
  end
end
