defmodule RabbitChatWeb.ChatterLiveTest do
  use RabbitChatWeb.ConnCase

  import Phoenix.LiveViewTest
  import RabbitChat.ChatContextFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_chatter(_) do
    chatter = chatter_fixture()
    %{chatter: chatter}
  end

  describe "Index" do
    setup [:create_chatter]

    test "lists all chatters", %{conn: conn, chatter: chatter} do
      {:ok, _index_live, html} = live(conn, Routes.chatter_index_path(conn, :index))

      assert html =~ "Listing Chatters"
      assert html =~ chatter.name
    end

    test "saves new chatter", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.chatter_index_path(conn, :index))

      assert index_live |> element("a", "New Chatter") |> render_click() =~
               "New Chatter"

      assert_patch(index_live, Routes.chatter_index_path(conn, :new))

      assert index_live
             |> form("#chatter-form", chatter: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#chatter-form", chatter: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.chatter_index_path(conn, :index))

      assert html =~ "Chatter created successfully"
      assert html =~ "some name"
    end

    test "updates chatter in listing", %{conn: conn, chatter: chatter} do
      {:ok, index_live, _html} = live(conn, Routes.chatter_index_path(conn, :index))

      assert index_live |> element("#chatter-#{chatter.id} a", "Edit") |> render_click() =~
               "Edit Chatter"

      assert_patch(index_live, Routes.chatter_index_path(conn, :edit, chatter))

      assert index_live
             |> form("#chatter-form", chatter: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#chatter-form", chatter: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.chatter_index_path(conn, :index))

      assert html =~ "Chatter updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes chatter in listing", %{conn: conn, chatter: chatter} do
      {:ok, index_live, _html} = live(conn, Routes.chatter_index_path(conn, :index))

      assert index_live |> element("#chatter-#{chatter.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#chatter-#{chatter.id}")
    end
  end

  describe "Show" do
    setup [:create_chatter]

    test "displays chatter", %{conn: conn, chatter: chatter} do
      {:ok, _show_live, html} = live(conn, Routes.chatter_show_path(conn, :show, chatter))

      assert html =~ "Show Chatter"
      assert html =~ chatter.name
    end

    test "updates chatter within modal", %{conn: conn, chatter: chatter} do
      {:ok, show_live, _html} = live(conn, Routes.chatter_show_path(conn, :show, chatter))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Chatter"

      assert_patch(show_live, Routes.chatter_show_path(conn, :edit, chatter))

      assert show_live
             |> form("#chatter-form", chatter: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#chatter-form", chatter: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.chatter_show_path(conn, :show, chatter))

      assert html =~ "Chatter updated successfully"
      assert html =~ "some updated name"
    end
  end
end
