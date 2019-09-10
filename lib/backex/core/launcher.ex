defmodule Backex.Core.Launcher do
  @moduledoc false

  alias Backex.Core.State

  alias Backex.{
    Utils,
    Backoffer,
    CircleBreaker
  }

  @default_state %State{}

  def execute(request, state \\ @default_state) do
    try do
      Utils.apply(request.callable)
    rescue
      e -> handle_error(e, request, state)
    end
  end

  defp handle_error(e, request, state) do
    if CircleBreaker.breaking?(request, state) do
      raise e
    else
      backoff_and_retry(request, state)
    end
  end

  defp backoff_and_retry(request, state) do
    backoff = Backoffer.backoff(request, state)

    :timer.sleep(backoff)

    state = State.inc_retry(state)
    execute(request, state)
  end
end
