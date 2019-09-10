defmodule Backex.Backoffer do
  @moduledoc """
  Behavior and utilites to generate backoff timeout
  """
  alias Backex.{
    Backoffer,
    BuildIn
  }

  @doc """
  Function that based on execution status and backoff of previous
  backoffer from list of backoffer will generate next backoff
  """
  @callback backoff(integer(), %Backex.Core.State{}, any()) :: integer()

  @build_in %{
    :jitter => Backoffer.Jitter,
    :linear_backoff => Backoffer.LinearBackoff,
    :exponential_backoff => Backoffer.ExponentialBackoff,
    :max_backoff => Backoffer.MaxBackoff
  }

  def replace_build_in(request) do
    BuildIn.replace_build_in(request, :backoffers, @build_in)
  end

  def backoff(request, state) do
    Enum.reduce(request.backoffers, request.backoff, fn {backoffer, value}, backoff ->
      backoffer.backoff(backoff, state, value)
    end)
  end
end
