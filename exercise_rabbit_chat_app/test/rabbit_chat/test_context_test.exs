defmodule RabbitChat.TestContextTest do
  use RabbitChat.DataCase

  alias RabbitChat.TestContext

  describe "testers" do
    alias RabbitChat.TestContext.Test

    import RabbitChat.TestContextFixtures

    @invalid_attrs %{name: nil}

    test "list_testers/0 returns all testers" do
      test = test_fixture()
      assert TestContext.list_testers() == [test]
    end

    test "get_test!/1 returns the test with given id" do
      test = test_fixture()
      assert TestContext.get_test!(test.id) == test
    end

    test "create_test/1 with valid data creates a test" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Test{} = test} = TestContext.create_test(valid_attrs)
      assert test.name == "some name"
    end

    test "create_test/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TestContext.create_test(@invalid_attrs)
    end

    test "update_test/2 with valid data updates the test" do
      test = test_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Test{} = test} = TestContext.update_test(test, update_attrs)
      assert test.name == "some updated name"
    end

    test "update_test/2 with invalid data returns error changeset" do
      test = test_fixture()
      assert {:error, %Ecto.Changeset{}} = TestContext.update_test(test, @invalid_attrs)
      assert test == TestContext.get_test!(test.id)
    end

    test "delete_test/1 deletes the test" do
      test = test_fixture()
      assert {:ok, %Test{}} = TestContext.delete_test(test)
      assert_raise Ecto.NoResultsError, fn -> TestContext.get_test!(test.id) end
    end

    test "change_test/1 returns a test changeset" do
      test = test_fixture()
      assert %Ecto.Changeset{} = TestContext.change_test(test)
    end
  end
end
