require IEx
defmodule Spiders do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Task.Supervisor, [[name: Spiders.TaskSupervisor]])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def crawl(url) do
    {:ok, pid} = Task.Supervisor.start_link()
    task = Task.Supervisor.async(pid, fn ->
      {:ok, queue} = Spiders.Queue.new
      {:ok, output} = Spiders.Output.new
      uri = URI.parse(url)
      Spiders.Queue.push(queue, Spiders.Link.new(uri, "Root", uri))
      {:ok, spider} = Spiders.Spider.start_link(queue, output, url)
      Spiders.Spider.begin
    end)
    Task.await(task)
  end



  def main(args) do
    args |> parse_args |> process
  end

  def process(options) do
    Spiders.crawl(options[:url])
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args, switches: [url: :string])
   options
  end
end

