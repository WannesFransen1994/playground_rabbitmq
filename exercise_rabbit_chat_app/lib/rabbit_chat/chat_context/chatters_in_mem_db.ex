defmodule RabbitChat.ChatContext.ChattersInMemDB do
  use GenServer

  require Logger

  @me __MODULE__

  @enforce_keys [:chatters]
  defstruct [:chatters]

  # ###########################################################
  # API
  # ###########################################################

  def start_link(_args \\ []), do: GenServer.start_link(@me, :no_args, name: @me)

  def add_chatter(name) when is_binary(name), do: GenServer.call(@me, {:add_chatter, name})
  def list_chatters(), do: GenServer.call(@me, :list_chatters)
  def get_chatter(name), do: GenServer.call(@me, {:get_chatter, name})

  # ###########################################################
  # Callbacks
  # ###########################################################

  @impl true
  def handle_call({:add_chatter, name}, _from, %@me{} = state) do
    new_chatter = %RabbitChat.ChatContext.Chatter{name: name}
    new_chatters = Map.put_new(state.chatters, name, new_chatter)
    updated_state = %{state | chatters: new_chatters}

    {:reply, {:ok, new_chatter}, updated_state}
  end

  @impl true
  def handle_call(:list_chatters, _, %@me{chatters: cs} = state) do
    {:reply, Map.values(cs), state}
  end

  @impl true
  def handle_call({:get_chatter, name}, _from, %@me{chatters: cs} = state) do
    {:reply, Map.get(cs, name), state}
  end

  # ###########################################################
  # PURELY INTERNAL
  # ###########################################################

  @impl true
  def init(:no_args), do: {:ok, %@me{chatters: %{}}, {:continue, :seed_memory}}

  @impl true
  def handle_continue(:seed_memory, %@me{} = state) do
    a = %RabbitChat.ChatContext.Chatter{name: "a"}
    b = %RabbitChat.ChatContext.Chatter{name: "b"}
    c = %RabbitChat.ChatContext.Chatter{name: "c"}
    wannes = %RabbitChat.ChatContext.Chatter{name: "wannes"}

    new_chatters =
      state.chatters
      |> Map.put_new("a", a)
      |> Map.put_new("b", b)
      |> Map.put_new("c", c)
      |> Map.put_new("wannes", wannes)

    {:noreply, %{state | chatters: new_chatters}}
  end
end
