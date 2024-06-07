defmodule LoadTestsWeb.MessageLineLive.FormComponent do
  use LoadTestsWeb, :live_component

  alias LoadTests.Conversation

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage message_line records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="message_line-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:conversation_id]} type="number" label="Conversation" />
        <.input field={@form[:body]} type="text" label="Body" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Message line</.button>
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

  def handle_event("save", %{"message_line" => message_line_params}, socket) do
    save_message_line(socket, socket.assigns.action, message_line_params)
  end

  defp save_message_line(socket, :edit, message_line_params) do
    case Conversation.update_message_line(socket.assigns.message_line, message_line_params) do
      {:ok, message_line} ->
        notify_parent({:saved, message_line})

        {:noreply,
         socket
         |> put_flash(:info, "Message line updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_message_line(socket, :new, message_line_params) do
    case Conversation.create_message_line(message_line_params) do
      {:ok, message_line} ->
        notify_parent({:saved, message_line})

        {:noreply,
         socket
         |> put_flash(:info, "Message line created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
