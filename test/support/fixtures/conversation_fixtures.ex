defmodule LoadTests.ConversationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LoadTests.Conversation` context.
  """

  @doc """
  Generate a message_line.
  """
  def message_line_fixture(attrs \\ %{}) do
    {:ok, message_line} =
      attrs
      |> Enum.into(%{
        body: "some body",
        conversation_id: 42
      })
      |> LoadTests.Conversation.create_message_line()

    message_line
  end
end
