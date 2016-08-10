defmodule Spiders.Output do
  def new do
    Agent.start_link(fn -> %MapSet{} end, name: __MODULE__)
  end

  def push(pid, page_record) do
    Agent.update(pid, fn(q) -> MapSet.put(q, page_record) end)
  end

  def take_all(pid) do
    Agent.get_and_update(pid, fn(q) ->
      {q, %MapSet{}}
    end)
  end
end
