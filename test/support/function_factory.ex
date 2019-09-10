defmodule Test.Support.FunctionFactory do
  def crash_times(max_crashs) do
    Process.put(:try, 0)

    fn ->
      t = Process.get(:try)

      if t >= max_crashs do
        true
      else
        Process.put(:try, t + 1)
        raise "crash"
      end
    end
  end
end
