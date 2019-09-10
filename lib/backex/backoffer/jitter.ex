defmodule Backex.Backoffer.Jitter do
  @moduledoc false

  @behaviour Backex.Backoffer

  def backoff(b, _s, jitter) when jitter > 0 do
    b + :rand.uniform(jitter)
  end

  def backoff(b, _s, jitter) when jitter < 0 do
    b - :rand.uniform(abs(jitter))
  end

  def backoff(b, _s, _jitter), do: b
end
