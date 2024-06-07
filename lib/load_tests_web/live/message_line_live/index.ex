defmodule LoadTestsWeb.MessageLineLive.Index do
  use LoadTestsWeb, :live_view

  alias LoadTests.Conversation
  alias LoadTests.Conversation.MessageLine

  @impl true
  def mount(%{"room" => room}, _session, socket) do
    {:ok, stream(socket, :message_lines, Conversation.conversation(room))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id, "room" => room}) do
    socket
    |> assign(:page_title, "Edit Message line")
    |> assign(:room, room)
    |> assign(:message_line, Conversation.get_message_line!(id))
  end

  defp apply_action(socket, :new, %{"room" => room}) do
    socket
    |> assign(:page_title, "New Message line")
    |> assign(:room, room)
    |> assign(:message_line, %MessageLine{conversation_id: String.to_integer(room)})
  end

  defp apply_action(socket, :index, %{"room" => room}) do
    socket
    |> assign(:page_title, "Listing Message lines")
    |> assign(:room, room)
    |> assign(:message_line, %MessageLine{conversation_id: String.to_integer(room)})
  end

  @impl true
  def handle_info({LoadTestsWeb.MessageLineLive.FormComponent, {:saved, message_line}}, socket) do
    {:noreply, stream_insert(socket, :message_lines, message_line)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    message_line = Conversation.get_message_line!(id)
    {:ok, _} = Conversation.delete_message_line(message_line)

    {:noreply, stream_delete(socket, :message_lines, message_line)}
  end
end
