defmodule RabbitChat.ChatContext do
  alias RabbitChat.ChatContext.ChattersInMemDB
  alias RabbitChat.ChatContext.Chatter
  alias RabbitChat.ChatContext.Message

  def list_chatters do
    ChattersInMemDB.list_chatters()
  end

  def get_chatter!(name), do: ChattersInMemDB.get_chatter(name)

  def create_chatter(%{"name" => name}) do
    ChattersInMemDB.add_chatter(name)
  end

  def send_message(%Chatter{} = from, %Chatter{} = dest, msg) when is_binary(msg) do
    msg = %Message{sender: from.name, destination: dest.name, message: msg}

    RabbitChat.OTP.MessagePublisher.publish(dest.name, msg.message)

    {:ok, msg}
  end
end
