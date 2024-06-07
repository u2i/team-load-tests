defmodule LoadTestsWeb.MessageLineLive.Show do
  use LoadTestsWeb, :live_view

  alias LoadTests.Conversation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:message_line, Conversation.get_message_line!(id))}
  end

  defp page_title(:show), do: "Show Message line"
  defp page_title(:edit), do: "Edit Message line"
end
