defmodule BackexTest do
  alias Test.Support.FunctionFactory

  use ExUnit.Case

  doctest Backex

  test "execute function" do
    assert Backex.execute(fn -> true end)
  end

  test "max retries" do
    settings = [circle_breakers: [max_retries: 1]]
    func = FunctionFactory.crash_times(1)
    assert Backex.execute(func, settings)

    func = FunctionFactory.crash_times(2)

    assert_raise RuntimeError, fn ->
      Backex.execute(func, settings)
    end
  end

  test "linear backoff" do
    settings = [backoffers: [linear_backoff: 1000]]
    func = FunctionFactory.crash_times(3)

    {time, true} = :timer.tc(fn -> Backex.execute(func, settings) end)
    assert 60 == floor(time / 100_000)
  end

  test "exponential backoff" do
    settings = [backoffers: [exponential_backoff: 1.1]]
    func = FunctionFactory.crash_times(2)

    {time, true} = :timer.tc(fn -> Backex.execute(func, settings) end)
    assert 21 == floor(time / 100_000)
  end

  test "linear backoff with max backoff" do
    settings = [
      backoffers: [
        linear_backoff: 1000,
        max_backoff: 2000
      ]
    ]

    func = FunctionFactory.crash_times(4)
    {time, true} = :timer.tc(fn -> Backex.execute(func, settings) end)
    assert 70 == floor(time / 100_000)
  end

  test "positive jitter" do
    settings = [
      backoffers: [jitter: 100]
    ]

    func = FunctionFactory.crash_times(5)
    {time, true} = :timer.tc(fn -> Backex.execute(func, settings) end)
    time = floor(time / 100_000)

    assert time > 50
    assert time <= 55
  end

  test "negative jitter" do
    settings = [
      backoffers: [
        jitter: -100
      ]
    ]

    func = FunctionFactory.crash_times(5)
    {time, true} = :timer.tc(fn -> Backex.execute(func, settings) end)
    time = floor(time / 100_000)

    assert time <= 50
    assert time > 45
  end
end
