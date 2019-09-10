defmodule Backex.Core.State do
  @moduledoc """
  Structure that is representing state of execution,
  is used in behaviours to determine backoff or if execution
  should be broken
  """

  defstruct retry: 0

  def new(), do: %__MODULE__{}

  def inc_retry(state) do
    Map.put(state, :retry, state.retry + 1)
  end
end
