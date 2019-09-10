defmodule Backex.CircleBreaker do
  @moduledoc """
  Utilities and behaviour to create circle breaking
  """
  alias Backex.{
    CircleBreaker,
    BuildIn
  }

  @doc """
  Function that get execution state and decide if it is time to
  stop retriing of call
  """
  @callback breaking?(%Backex.Core.State{}, any()) :: boolean()

  @build_in %{
    :max_retries => CircleBreaker.MaxRetries
  }

  def replace_build_in(request) do
    BuildIn.replace_build_in(request, :circle_breakers, @build_in)
  end

  def breaking?(request, state) do
    Enum.any?(request.circle_breakers, fn {circle_breaker, value} ->
      circle_breaker.breaking?(state, value)
    end)
  end
end
