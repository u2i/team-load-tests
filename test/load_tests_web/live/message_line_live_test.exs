defmodule LoadTestsWeb.MessageLineLiveTest do
  use LoadTestsWeb.ConnCase

  import Phoenix.LiveViewTest
  import LoadTests.ConversationFixtures

  @create_attrs %{body: "some body", conversation_id: 42}
  @update_attrs %{body: "some updated body", conversation_id: 43}
  @invalid_attrs %{body: nil, conversation_id: nil}

  defp create_message_line(_) do
    message_line = message_line_fixture()
    %{message_line: message_line}
  end

  describe "Index" do
    setup [:create_message_line]

    test "lists all message_lines", %{conn: conn, message_line: message_line} do
      {:ok, _index_live, html} = live(conn, ~p"/message_lines")

      assert html =~ "Listing Message lines"
      assert html =~ message_line.body
    end

    test "saves new message_line", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/message_lines")

      assert index_live |> element("a", "New Message line") |> render_click() =~
               "New Message line"

      assert_patch(index_live, ~p"/message_lines/new")

      assert index_live
             |> form("#message_line-form", message_line: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#message_line-form", message_line: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/message_lines")

      html = render(index_live)
      assert html =~ "Message line created successfully"
      assert html =~ "some body"
    end

    test "updates message_line in listing", %{conn: conn, message_line: message_line} do
      {:ok, index_live, _html} = live(conn, ~p"/message_lines")

      assert index_live |> element("#message_lines-#{message_line.id} a", "Edit") |> render_click() =~
               "Edit Message line"

      assert_patch(index_live, ~p"/message_lines/#{message_line}/edit")

      assert index_live
             |> form("#message_line-form", message_line: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#message_line-form", message_line: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/message_lines")

      html = render(index_live)
      assert html =~ "Message line updated successfully"
      assert html =~ "some updated body"
    end

    test "deletes message_line in listing", %{conn: conn, message_line: message_line} do
      {:ok, index_live, _html} = live(conn, ~p"/message_lines")

      assert index_live |> element("#message_lines-#{message_line.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#message_lines-#{message_line.id}")
    end
  end

  describe "Show" do
    setup [:create_message_line]

    test "displays message_line", %{conn: conn, message_line: message_line} do
      {:ok, _show_live, html} = live(conn, ~p"/message_lines/#{message_line}")

      assert html =~ "Show Message line"
      assert html =~ message_line.body
    end

    test "updates message_line within modal", %{conn: conn, message_line: message_line} do
      {:ok, show_live, _html} = live(conn, ~p"/message_lines/#{message_line}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Message line"

      assert_patch(show_live, ~p"/message_lines/#{message_line}/show/edit")

      assert show_live
             |> form("#message_line-form", message_line: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#message_line-form", message_line: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/message_lines/#{message_line}")

      html = render(show_live)
      assert html =~ "Message line updated successfully"
      assert html =~ "some updated body"
    end
  end
end
