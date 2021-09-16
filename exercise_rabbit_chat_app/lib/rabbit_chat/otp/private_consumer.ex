defmodule RabbitChat.OTP.PrivateConsumer do
  use GenServer, restart: :transient
  use AMQP

  require IEx

  # Most of this code is from https://hexdocs.pm/amqp/readme.html#setup-a-consumer-genserver

  @channel :private_chat_consume_channel
  @exchange "wannes-chat-exchange"

  @me __MODULE__

  @enforce_keys [:channel, :consumer_tag, :queue, :receiver_pid]
  defstruct [:channel, :consumer_tag, :queue, :receiver_pid]

  def start_link(args \\ []), do: GenServer.start_link(@me, args)
  def shutdown(pid), do: GenServer.stop(pid, :normal)

  def init(args) do
    user = args[:user] || raise "Can't start a consumer if it doesn't know the consuming user..."
    pid = args[:web_pid] || raise "Can't report if I don't have the pid..."

    {:ok, amqp_channel} = AMQP.Application.get_channel(@channel)
    queue = "#{user}-private-messages"
    {:ok, _} = Queue.declare(amqp_channel, queue, auto_delete: true)
    :ok = Queue.bind(amqp_channel, queue, @exchange, routing_key: queue)
    :ok = Basic.qos(amqp_channel, prefetch_count: 1)
    {:ok, consumer_tag} = Basic.consume(amqp_channel, queue)

    state = %@me{
      channel: amqp_channel,
      consumer_tag: consumer_tag,
      queue: queue,
      receiver_pid: pid
    }

    {:ok, state}
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: _consumer_tag}}, %@me{} = state) do
    # do nothing?
    {:noreply, state}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: _consumer_tag}}, %@me{} = state) do
    # do nothing? No cleanup needs to happen?
    {:stop, :normal, state}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: _consumer_tag}}, %@me{} = state) do
    # do nothing? No cleanup needs to happen?
    {:noreply, state}
  end

  def handle_info({:basic_deliver, payload, meta_info}, %@me{channel: c, receiver_pid: pid} = s) do
    send(pid, {:new_message, payload})
    Basic.ack(c, meta_info.delivery_tag)

    {:noreply, %@me{} = s}
  end

  def terminate(_whatever_reason, %@me{} = state) do
    AMQP.Queue.unsubscribe(state.channel, state.consumer_tag)
    :ignored_return_value
  end
end
