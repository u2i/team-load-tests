defmodule LoadTestsWeb.MessageLineLiveTest do
  use LoadTestsWeb.ConnCase

  import Phoenix.LiveViewTest
  import LoadTests.ConversationFixtures

  @create_attrs %{body: "some body"}
  @update_attrs %{body: "some updated body"}
  @invalid_attrs %{body: nil}

  defp create_message_line(_) do
    message_line = message_line_fixture(conversation_id: 1)
    %{message_line: message_line}
  end

  describe "Index" do
    setup [:create_message_line]

    test "lists all message_lines", %{conn: conn, message_line: message_line} do
      {:ok, _index_live, html} = live(conn, ~p"/conversation/1")

      assert html =~ "Conversation #1"
      assert html =~ message_line.body
    end

    test "saves new message_line", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/conversation/1")

      assert index_live
        |> form("#message-form-new", message_line: @invalid_attrs)
        |> render_change() =~ "can&#39;t be blank"

      assert index_live
        |> form("#message-form-new", message_line: @create_attrs)
        |> render_submit()

      assert_patch(index_live, ~p"/conversation/1")

      html = render(index_live)
      assert html =~ "Message created successfully"
      assert html =~ "some body"
    end

    test "updates message_line in listing", %{conn: conn, message_line: message_line} do
      {:ok, index_live, _html} = live(conn, ~p"/conversation/1")

      assert index_live |> element("#message_lines-#{message_line.id} a", "Edit") |> render_click() =~
        "Edit Message"

      assert_patch(index_live, ~p"/conversation/1/messages/#{message_line}/edit")

      assert index_live
        |> form("#message-form-#{message_line.id}", message_line: @invalid_attrs)
        |> render_change() =~ "can&#39;t be blank"

      assert index_live
        |> form("#message-form-#{message_line.id}", message_line: @update_attrs)
        |> render_submit()

      assert_patch(index_live, ~p"/conversation/1")

      html = render(index_live)
      assert html =~ "Message updated successfully"
      assert html =~ "some updated body"
    end

    test "deletes message_line in listing", %{conn: conn, message_line: message_line} do
      {:ok, index_live, _html} = live(conn, ~p"/conversation/1")

      assert index_live
        |> element("#message_lines-#{message_line.id} a", "Delete") |> render_click()

      refute has_element?(index_live, "#message_lines-#{message_line.id}")
    end
  end
end
