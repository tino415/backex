defmodule Backex.Backoffer.ExponentialBackoff do
  @moduledoc false

  @behaviour Backex.Backoffer

  def backoff(b, s, exp) when exp > 0 do
    floor(b * :math.pow(exp, s.retry))
  end
end
