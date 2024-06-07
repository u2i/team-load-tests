defmodule LoadTests.Conversation do
  @moduledoc """
  The Conversation context.
  """

  import Ecto.Query, warn: false
  alias LoadTests.Repo

  alias LoadTests.Conversation.MessageLine

  @doc """
  Returns the list of message_lines.

  ## Examples

      iex> list_message_lines()
      [%MessageLine{}, ...]

  """
  def list_message_lines do
    Repo.all(from m in MessageLine, order_by: [desc: m.id])
  end

  def conversation(id) do
    Repo.all(from m in MessageLine, where: m.conversation_id == ^id, order_by: [desc: m.id])
  end

  @doc """
  Gets a single message_line.

  Raises `Ecto.NoResultsError` if the Message line does not exist.

  ## Examples

      iex> get_message_line!(123)
      %MessageLine{}

      iex> get_message_line!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message_line!(id), do: Repo.get!(MessageLine, id)

  @doc """
  Creates a message_line.

  ## Examples

      iex> create_message_line(%{field: value})
      {:ok, %MessageLine{}}

      iex> create_message_line(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message_line(attrs \\ %{}) do
    %MessageLine{}
    |> MessageLine.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:message_created)
  end

  @doc """
  Updates a message_line.

  ## Examples

      iex> update_message_line(message_line, %{field: new_value})
      {:ok, %MessageLine{}}

      iex> update_message_line(message_line, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message_line(%MessageLine{} = message_line, attrs) do
    message_line
    |> MessageLine.changeset(attrs)
    |> Repo.update()
    |> broadcast(:message_updated)
  end

  @doc """
  Deletes a message_line.

  ## Examples

      iex> delete_message_line(message_line)
      {:ok, %MessageLine{}}

      iex> delete_message_line(message_line)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message_line(%MessageLine{} = message_line) do
    Repo.delete(message_line)
    |> broadcast(:message_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message_line changes.

  ## Examples

      iex> change_message_line(message_line)
      %Ecto.Changeset{data: %MessageLine{}}

  """
  def change_message_line(%MessageLine{} = message_line, attrs \\ %{}) do
    MessageLine.changeset(message_line, attrs)
  end

  def subscribe(id) do
    Phoenix.PubSub.subscribe(LoadTests.PubSub, "conversation-#{id}")
  end

  defp broadcast({:error, _reason} = error, _event), do: error
  defp broadcast({:ok, message}, event) do
    Phoenix.PubSub.broadcast(LoadTests.PubSub, "conversation-#{message.conversation_id}", { event, message })

    {:ok, message}
  end
end
