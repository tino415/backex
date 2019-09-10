defmodule Backex.Core.Request do
  @moduledoc false

  @enforce_keys [:callable]

  defstruct [
    :callable,
    backoff: 1000,
    backoffers: [],
    circle_breakers: []
  ]

  def new(callable, opts \\ []) do
    %__MODULE__{callable: callable}
    |> struct!(opts)
  end
end
