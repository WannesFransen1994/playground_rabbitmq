defmodule RabbitChatWeb.TestLiveTest do
  use RabbitChatWeb.ConnCase

  import Phoenix.LiveViewTest
  import RabbitChat.TestContextFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_test(_) do
    test = test_fixture()
    %{test: test}
  end

  describe "Index" do
    setup [:create_test]

    test "lists all testers", %{conn: conn, test: test} do
      {:ok, _index_live, html} = live(conn, Routes.test_index_path(conn, :index))

      assert html =~ "Listing Testers"
      assert html =~ test.name
    end

    test "saves new test", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.test_index_path(conn, :index))

      assert index_live |> element("a", "New Test") |> render_click() =~
               "New Test"

      assert_patch(index_live, Routes.test_index_path(conn, :new))

      assert index_live
             |> form("#test-form", test: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#test-form", test: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.test_index_path(conn, :index))

      assert html =~ "Test created successfully"
      assert html =~ "some name"
    end

    test "updates test in listing", %{conn: conn, test: test} do
      {:ok, index_live, _html} = live(conn, Routes.test_index_path(conn, :index))

      assert index_live |> element("#test-#{test.id} a", "Edit") |> render_click() =~
               "Edit Test"

      assert_patch(index_live, Routes.test_index_path(conn, :edit, test))

      assert index_live
             |> form("#test-form", test: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#test-form", test: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.test_index_path(conn, :index))

      assert html =~ "Test updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes test in listing", %{conn: conn, test: test} do
      {:ok, index_live, _html} = live(conn, Routes.test_index_path(conn, :index))

      assert index_live |> element("#test-#{test.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#test-#{test.id}")
    end
  end

  describe "Show" do
    setup [:create_test]

    test "displays test", %{conn: conn, test: test} do
      {:ok, _show_live, html} = live(conn, Routes.test_show_path(conn, :show, test))

      assert html =~ "Show Test"
      assert html =~ test.name
    end

    test "updates test within modal", %{conn: conn, test: test} do
      {:ok, show_live, _html} = live(conn, Routes.test_show_path(conn, :show, test))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Test"

      assert_patch(show_live, Routes.test_show_path(conn, :edit, test))

      assert show_live
             |> form("#test-form", test: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#test-form", test: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.test_show_path(conn, :show, test))

      assert html =~ "Test updated successfully"
      assert html =~ "some updated name"
    end
  end
end
