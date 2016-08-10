defmodule Spiders.QueueTest do
  use ExUnit.Case
  doctest Spiders.Queue

  test "acts like a queue" do
    {:ok, pid} = Spiders.Queue.new
    Spiders.Queue.push(pid, "http://google.com")
    assert Spiders.Queue.checkout(pid) == "http://google.com"
    assert Spiders.Queue.checkout(pid) == nil
  end
end

defmodule Spiders.OutputTest do
  use ExUnit.Case
  doctest Spiders.Output

  test "records can be added and gathered" do
    {:ok, pid} = Spiders.Output.new
    Spiders.Output.push(pid, {:item1})
    Spiders.Output.push(pid, {:item2})
    assert Spiders.Output.take_all(pid) == MapSet.new([{:item1}, {:item2}])
  end
end

defmodule Spiders.Spider do
  use ExUnit.Case
  doctest Spiders.Output

  test "handles call to get next item from queue" do
    Spiders.start(nil, nil)
    assert GenServer.call(Spiders.Spider, :get) == {:reply, :ok}
  end
end
