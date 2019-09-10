defmodule Backex.CircleBreaker.MaxRetries do
  @moduledoc false

  @behaviour Backex.CircleBreaker
  def breaking?(%{retry: t}, max), do: t >= max
end
