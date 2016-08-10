defmodule Spiders.Link do
  defstruct from_url: nil, anchor: nil, to_url: nil, status: nil, completed: false

  def new(from_url, anchor, to_url) do
    %__MODULE__{
      from_url: from_url,
      anchor: anchor,
      to_url: to_url
    }
  end
end
