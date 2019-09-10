defmodule Backex.Backoffer.MaxBackoff do
  @moduledoc false

  @behaviour Backex.Backoffer

  def backoff(b, _s, :infinity), do: b

  def backoff(b, _s, max), do: min(b, max)
end
