defmodule LoadTests.ConversationTest do
  use LoadTests.DataCase

  alias LoadTests.Conversation

  describe "message_lines" do
    alias LoadTests.Conversation.MessageLine

    import LoadTests.ConversationFixtures

    @invalid_attrs %{body: nil, conversation_id: nil}

    test "list_message_lines/0 returns all message_lines" do
      message_line = message_line_fixture()
      assert Conversation.list_message_lines() == [message_line]
    end

    test "get_message_line!/1 returns the message_line with given id" do
      message_line = message_line_fixture()
      assert Conversation.get_message_line!(message_line.id) == message_line
    end

    test "create_message_line/1 with valid data creates a message_line" do
      valid_attrs = %{body: "some body", conversation_id: 42}

      assert {:ok, %MessageLine{} = message_line} = Conversation.create_message_line(valid_attrs)
      assert message_line.body == "some body"
      assert message_line.conversation_id == 42
    end

    test "create_message_line/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Conversation.create_message_line(@invalid_attrs)
    end

    test "update_message_line/2 with valid data updates the message_line" do
      message_line = message_line_fixture()
      update_attrs = %{body: "some updated body", conversation_id: 43}

      assert {:ok, %MessageLine{} = message_line} = Conversation.update_message_line(message_line, update_attrs)
      assert message_line.body == "some updated body"
      assert message_line.conversation_id == 43
    end

    test "update_message_line/2 with invalid data returns error changeset" do
      message_line = message_line_fixture()
      assert {:error, %Ecto.Changeset{}} = Conversation.update_message_line(message_line, @invalid_attrs)
      assert message_line == Conversation.get_message_line!(message_line.id)
    end

    test "delete_message_line/1 deletes the message_line" do
      message_line = message_line_fixture()
      assert {:ok, %MessageLine{}} = Conversation.delete_message_line(message_line)
      assert_raise Ecto.NoResultsError, fn -> Conversation.get_message_line!(message_line.id) end
    end

    test "change_message_line/1 returns a message_line changeset" do
      message_line = message_line_fixture()
      assert %Ecto.Changeset{} = Conversation.change_message_line(message_line)
    end
  end
end
