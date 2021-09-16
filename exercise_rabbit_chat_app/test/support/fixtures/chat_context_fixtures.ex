defmodule RabbitChat.ChatContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RabbitChat.ChatContext` context.
  """

  @doc """
  Generate a chatter.
  """
  def chatter_fixture(attrs \\ %{}) do
    {:ok, chatter} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> RabbitChat.ChatContext.create_chatter()

    chatter
  end
end
