defmodule RabbitChat.ChatContextTest do
  use RabbitChat.DataCase

  alias RabbitChat.ChatContext

  describe "chatters" do
    alias RabbitChat.ChatContext.Chatter

    import RabbitChat.ChatContextFixtures

    @invalid_attrs %{name: nil}

    test "list_chatters/0 returns all chatters" do
      chatter = chatter_fixture()
      assert ChatContext.list_chatters() == [chatter]
    end

    test "get_chatter!/1 returns the chatter with given id" do
      chatter = chatter_fixture()
      assert ChatContext.get_chatter!(chatter.id) == chatter
    end

    test "create_chatter/1 with valid data creates a chatter" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Chatter{} = chatter} = ChatContext.create_chatter(valid_attrs)
      assert chatter.name == "some name"
    end

    test "create_chatter/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ChatContext.create_chatter(@invalid_attrs)
    end

    test "update_chatter/2 with valid data updates the chatter" do
      chatter = chatter_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Chatter{} = chatter} = ChatContext.update_chatter(chatter, update_attrs)
      assert chatter.name == "some updated name"
    end

    test "update_chatter/2 with invalid data returns error changeset" do
      chatter = chatter_fixture()
      assert {:error, %Ecto.Changeset{}} = ChatContext.update_chatter(chatter, @invalid_attrs)
      assert chatter == ChatContext.get_chatter!(chatter.id)
    end

    test "delete_chatter/1 deletes the chatter" do
      chatter = chatter_fixture()
      assert {:ok, %Chatter{}} = ChatContext.delete_chatter(chatter)
      assert_raise Ecto.NoResultsError, fn -> ChatContext.get_chatter!(chatter.id) end
    end

    test "change_chatter/1 returns a chatter changeset" do
      chatter = chatter_fixture()
      assert %Ecto.Changeset{} = ChatContext.change_chatter(chatter)
    end
  end
end
