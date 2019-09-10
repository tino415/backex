defmodule Backex.Backoffer.LinearBackoff do
  @moduledoc false

  @behaviour Backex.Backoffer

  def backoff(backoff, state, offset) do
    floor(backoff + offset * state.retry)
  end
end
