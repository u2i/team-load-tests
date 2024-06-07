defmodule LoadTestsWeb.MessageLineLive.FormComponent do
  use LoadTestsWeb, :live_component

  alias LoadTests.Conversation

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id={"message-form-#{assigns.id}"}
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:body]} type="textarea" label={assigns.title} />
        <:actions>
          <.button phx-disable-with="Sending ...">
            <%= if assigns.id == :new, do: "Send", else: "Update message" %>
          </.button>

          <%= if assigns.id != :new do %>
            <.link patch={assigns.patch}>Cancel</.link>
          <% end %>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{message_line: message_line} = assigns, socket) do
    changeset = Conversation.change_message_line(message_line)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"message_line" => message_line_params}, socket) do
    changeset =
      socket.assigns.message_line
      |> Conversation.change_message_line(message_line_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"message_line" => message_line_params}, socket) do
    message_params = Map.put(message_line_params, "conversation_id", socket.assigns.room)
    action = if socket.assigns.action == :edit, do: :edit, else: :new

    save_message_line(socket, action, message_params)
  end

  @impl true
  def handle_async(:reply, _result, socket) do
    {:noreply, socket}
  end

  defp save_message_line(socket, :edit, message_line_params) do
    case Conversation.update_message_line(socket.assigns.message_line, message_line_params) do
      {:ok, message_line} ->
        {:noreply,
         socket
         |> put_flash(:info, "Message updated successfully")
         |> start_async(:reply, fn ->
              reply(message_line, "Oh wait, changed your mind?")
            end)
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_message_line(socket, :new, message_line_params) do
    case Conversation.create_message_line(message_line_params) do
      {:ok, message_line} ->
        empty = Conversation.MessageLine.changeset(%Conversation.MessageLine{}, %{})

        {:noreply,
         socket
         |> put_flash(:info, "Message created successfully")
         |> assign(form: to_form(empty))
         |> start_async(:reply, fn ->
              reply(message_line, "Tell me more!")
              reply(message_line, "I'm still here!")
            end)
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp reply(message_line, body) do
    Process.sleep(1000)

    Conversation.create_message_line(%{
      conversation_id: message_line.conversation_id,
      body: body
    })
  end
end
