
defmodule LoadTestsWeb.ChatLive do
  use LoadTestsWeb, :live_view

  import Ecto.Query

  def mount(params, _session, socket) do
    # message = %LoadTests.Chat.Message{}
    # {:ok, assign(socket, form: message |> to_form())}
    form = LoadTests.Chat.Message.changeset(%LoadTests.Chat.Message{}, %{})
    {:ok, assign(socket, form: to_form(form), chat_id: params["id"], messages: get_messages(params["id"]))}
  end

  def handle_event("save", %{"message" => message_params}, socket) do
    IO.puts("***************")
    IO.puts("before changeset")

    # %{"message" => %{"message" => "HELLO"}}
    message_params = Map.put(message_params, "chat_id", socket.assigns.chat_id)
    IO.inspect(message_params)
    case LoadTests.Chat.Message.changeset(%LoadTests.Chat.Message{}, message_params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        LoadTests.Repo.insert(changeset)
        IO.puts("HELLO WORLD!!!")
        form = LoadTests.Chat.Message.changeset(%LoadTests.Chat.Message{}, %{})
        socket =
          assign(socket, form: to_form(form), messages: get_messages(socket.assigns.chat_id))
          |> start_async(:my_task, fn ->
            # sleep for .5 seconds
            Process.sleep(500)
            changeset = LoadTests.Chat.Message.changeset(%LoadTests.Chat.Message{},
              %{"chat_id" => socket.assigns.chat_id,
                "message" => "Tell me more!"})
            LoadTests.Repo.insert(changeset)
          end)

        {:noreply, socket}

      %Ecto.Changeset{valid?: false} = changeset ->
        IO.puts("failed validation")
        IO.inspect(changeset.errors)
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("change", %{"message" => message_params}, socket) do
    form = LoadTests.Chat.Message.changeset(%LoadTests.Chat.Message{}, message_params)
    {:noreply, assign(socket, form: to_form(form))}
  end

  def handle_async(:my_task, {:ok, _ }, socket) do
    {:noreply, assign(socket, messages: get_messages(socket.assigns.chat_id))}
  end

  def get_messages(chat_id) do
    (from m in LoadTests.Chat.Message, where: m.chat_id == ^chat_id, select: m)
    |> LoadTests.Repo.all()
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Chat</h1>
      <div :for={message <- @messages} do>
        <%= message.message %>
      </div>

      <div>
        <.simple_form id="form" phx-change="change" for={@form} phx-submit="save">
          <.input field={@form[:message]} label="Message" />
          <:actions>
            <.button>Send</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end
end
