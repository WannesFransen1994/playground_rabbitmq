defmodule RabbitChat.OTP.DynamicConsumerManager do
  use GenServer

  defstruct user_pid_map: %{}

  # ###########################################################
  # API
  # ###########################################################

  @me __MODULE__
  def start_link(args \\ []), do: GenServer.start_link(@me, args, name: @me)
  def report_pid(name, pid), do: GenServer.call(@me, {:report_pid, name, pid})

  # ###########################################################
  # Callbacks
  # ###########################################################

  @impl true
  def handle_call({:report_pid, name, pid}, _from, %@me{} = s)
      when is_binary(name) and is_pid(pid) do
    {:reply, :ok, s, {:continue, {:start_consumer, name, pid}}}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, web_pid, _reason}, %@me{user_pid_map: upm} = s) do
    entry = Map.get(upm, web_pid)
    updated_state = %{s | user_pid_map: Map.delete(upm, web_pid)}
    RabbitChat.OTP.PrivateConsumer.shutdown(entry.consumer_pid)
    {:noreply, updated_state}
  end

  # ###########################################################
  # PURELY INTERNAL
  # ###########################################################

  @impl true
  def init(_args), do: {:ok, %@me{}}

  @impl true
  def handle_continue({:start_consumer, name, web_pid}, %@me{user_pid_map: upm} = state) do
    Process.monitor(web_pid)
    arguments = [user: name, web_pid: web_pid]

    {:ok, consumer_pid} =
      DynamicSupervisor.start_child(
        RabbitChat.OTP.ConsumerDynSup,
        {RabbitChat.OTP.PrivateConsumer, arguments}
      )

    new_upm = Map.put_new(upm, web_pid, %{name: name, consumer_pid: consumer_pid})
    updated_state = %{state | user_pid_map: new_upm}

    {:noreply, updated_state}
  end
end
