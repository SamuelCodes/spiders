require Logger

defmodule Spiders.Queue do
  def new do
    Agent.start_link(fn -> HashSet.new end, name: __MODULE__)
  end

  def any?(pid) do
    Agent.get(pid, fn(q) -> HashSet.size(q) > 0 end)
  end

  def push(pid, url) do
    Logger.debug("Queue.push(#{inspect pid}, from: #{URI.to_string(url.from_url)}, to: #{URI.to_string(url.to_url)}) #{Agent.get(pid, fn(x) -> HashSet.size(x) end)}")
    Agent.update(pid, fn(q) -> if Set.member?(q, url), do: q, else: HashSet.put(q, url) end)
  end

  def checkout(pid) do
    Logger.debug("Queue.checkout(#{inspect pid}) #{Agent.get(pid, fn(x) -> HashSet.size(x) end)}")
    Agent.get_and_update(pid, fn(q) ->
      item = Enum.at(q, 0)
      {item, HashSet.delete(q, item)}
    end)
  end
end
