defmodule Backex do
  alias Backex.Core.{
    Request,
    Launcher
  }

  alias Backex.{
    Backoffer,
    CircleBreaker
  }

  @moduledoc """
  Backex is extensible library for retry and bockoff of function calls
  """

  @typedoc """
  Option to set up circle breakers, for now supports onli
  breaking on max retries, custom circle breaker can by implemented
  by implementing Backex.CircleBreaker behaviour
  """
  @type circle_breaker() ::
          {:max_retries, integer()}
          | {atom(), any()}

  @typedoc """
  Option for backoff timeout, there is several of these supported
  * exponential backoff (backoff by multipling base backoff)
  * jitter substract or add random number of milliseconds from backoff
  * linear backoff increase or decrease backoff by constant value
  * custom, this list is accpeting tuples like {Module.Implementing.Backoffer.Behavior, arguments}
  """
  @type backoffer() ::
          {:exponential_backoff, float()}
          | {:jitter, integer()}
          | {:linear_backoff, integer()}
          | {:max_backoff, integer()}
          | {atom(), any()}

  @type circle_breakers :: [circle_breaker()]
  @type backoffers :: [backoffer()]
  @type option :: {:backoffers, backoffers()} | {:circle_breakers, circle_breakers()}
  @type options() :: [option()]
  @type callback() :: mfa() | function()

  @doc """
  Execute function in current process and retry with backoff if
  function fail

  ## Examples

  iex> Backex.execute(fn -> true end, backoff: 1000, circle_breakers: [max_retries: 3], backoffers: [linear_backoff: 1000])
  true
  """
  @spec execute(callback()) :: any()
  @spec execute(callback(), options()) :: any()
  def execute(callback, opts \\ []) do
    callback
    |> Request.new(opts)
    |> Backoffer.replace_build_in()
    |> CircleBreaker.replace_build_in()
    |> Launcher.execute()
  end
end
