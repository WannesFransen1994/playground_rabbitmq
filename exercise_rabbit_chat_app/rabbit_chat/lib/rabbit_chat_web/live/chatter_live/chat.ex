defmodule RabbitChatWeb.ChatterLive.Chat do
  use RabbitChatWeb, :live_view

  alias RabbitChat.ChatContext

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"from" => from, "to" => to}, _, socket) do
    new_socket =
      socket
      |> assign(:page_title, "#{from}-#{to}")
      |> assign(:log, [])
      |> assign(:current_chatter, ChatContext.get_chatter!(from))
      |> assign(:destination_chatter, ChatContext.get_chatter!(to))

    RabbitChat.OTP.DynamicConsumerManager.report_pid(from, self())

    {:noreply, new_socket}
  end

  @impl true
  def handle_event("save", %{"message" => %{"message" => payload}}, socket) do
    from = socket.assigns.current_chatter
    to = socket.assigns.destination_chatter

    case ChatContext.send_message(from, to, payload) do
      {:ok, msg} ->
        new_socket =
          socket
          |> assign(:log, [msg | socket.assigns.log])

        {:noreply, new_socket}
    end
  end

  @impl true
  def handle_info({:new_message, payload}, socket) do
    from = socket.assigns.destination_chatter
    to = socket.assigns.current_chatter

    msg = %RabbitChat.ChatContext.Message{
      message: payload,
      sender: from.name,
      destination: to.name
    }

    new_socket =
      socket
      |> assign(:log, [msg | socket.assigns.log])

    {:noreply, new_socket}
  end
end
