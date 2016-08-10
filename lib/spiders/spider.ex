defmodule Spiders.Spider do
  use Supervisor

  def begin do
    Enum.each(crawlers(__MODULE__), fn(child) ->
      GenServer.call(child, :process, :infinity)
    end)
  end

  def crawlers(name) do
    name
    |> Supervisor.which_children
    |> Enum.map(fn({_, child, _, _}) -> child end)
  end

  ###
  # Supervisor API
  ##
  def start_link(queue, output, name) do
    Supervisor.start_link(__MODULE__, [queue, output, name], name: __MODULE__)
  end


  def init([queue, output, name]) do
    IO.puts("Spider.init(#{name})")

    children = [
      worker(Spiders.Crawl, [queue, output], restart: :transient)
    ]

    # Begin processes to crawll and manage queue and output
    supervise(children, strategy: :one_for_one)
  end
end
