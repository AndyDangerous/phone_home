defmodule PhoneHome.Timer do
  use GenServer

  ##Server API

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  ## Server Callbacks

  # def init(:ok) do
  #   set up the ets table
  # end

end
