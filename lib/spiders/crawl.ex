require Logger

defmodule Spiders.Crawl do
  use GenServer
  use HTTPotion.Base

  def start_link(queue, output) do
    GenServer.start_link(__MODULE__, [queue, output], name: Crawler)
  end

  def init([queue, output]) do
    IO.puts("Crawl.init")
    {:ok, {queue, output}}
  end

  def handle_call(:process, _from, {queue, output}) do
    Logger.debug("Crawl.handle_call({:process}, ..")
    process(queue, output, Spiders.Queue.any?(queue))
  end

  def handle_cast({:process}, {queue, output}) do
    Logger.debug("Crawl.handle_cast({:process}, ..")
    Spiders.Crawl.process(queue, output, has_queue = Spiders.Queue.any?(queue))
  end

  def process(queue, output, has_queue) when has_queue do
    link = Spiders.Queue.checkout(queue)
    response = HTTPotion.get(link.to_url, follow_redirects: true)

    Logger.debug("Crawl.process: GET #{URI.to_string(link.to_url)}; Status: #{response.status_code}")

    ulink = %Spiders.Link{link| status: response.status_code}
    ulink
    |> extract_links(response)
    |> Enum.filter(fn(v) -> v end)
    |> Enum.each(fn(l) -> Spiders.Queue.push(queue, l) end)

    process(queue, output, Spiders.Queue.any?(queue))
  end

  def process(queue, output, has_queue) do
    {:reply, :ok}
  end

  def extract_links(link, response) do
    if response.status_code == 200 do
      response.body
      |> Floki.find("a")
      |> make_link(link)
    else
      []
    end
  end

  def make_link(as, link) do
    Enum.map(as, fn(a) ->
      href = Enum.at(a |> Floki.attribute("href"), 0)
      if href != nil do
        case valid_link?(link.to_url, href) do
          true  -> %Spiders.Link{from_url: link.to_url, anchor: a|>Floki.text, to_url: URI.merge(link.to_url, href)}
          _ -> nil
        end
      end
    end)
  end

  def valid_link?(from_url, to_url) do
    merged_url = URI.merge(from_url, to_url)
    if merged_url.host == from_url.host do
      true
    end
  end

end
