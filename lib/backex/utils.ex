defmodule Backex.Utils do
  @moduledoc false

  def apply({module, fun, args}) do
    Kernel.apply(module, fun, args)
  end

  def apply({fun, args}) do
    Kernel.apply(fun, args)
  end

  def apply(fun) do
    fun.()
  end
end
