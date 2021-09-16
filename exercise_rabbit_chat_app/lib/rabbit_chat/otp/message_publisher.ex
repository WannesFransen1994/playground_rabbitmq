defmodule RabbitChat.OTP.MessagePublisher do
  use GenServer
  require IEx
  require Logger

  @channel :produce_channel
  @exchange "wannes-chat-exchange"

  @me __MODULE__

  @enforce_keys [:channel]
  defstruct [:channel]

  # ###########################################################
  # API
  # ###########################################################

  def start_link(_args \\ []), do: GenServer.start_link(@me, :no_opts, name: @me)
  def publish(to, payload), do: GenServer.cast(@me, {:publish_message, to, payload})

  # ###########################################################
  # CALLBACKS
  # ###########################################################
  @impl true
  def handle_cast({:publish_message, to, payload}, %@me{channel: c} = state)
      when is_binary(payload) do
    :ok = AMQP.Basic.publish(c, @exchange, "#{to}-private-messages", payload)
    {:noreply, state}
  end

  # ###########################################################
  # PURELY INTERNAL
  # ###########################################################

  @impl true
  def init(:no_opts) do
    {:ok, amqp_channel} = AMQP.Application.get_channel(@channel)
    state = %@me{channel: amqp_channel}
    :ok = AMQP.Exchange.declare(state.channel, @exchange, :direct, durable: true)

    {:ok, state}
  end
end
