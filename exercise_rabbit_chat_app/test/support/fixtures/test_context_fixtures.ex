defmodule RabbitChat.TestContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RabbitChat.TestContext` context.
  """

  @doc """
  Generate a test.
  """
  def test_fixture(attrs \\ %{}) do
    {:ok, test} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> RabbitChat.TestContext.create_test()

    test
  end
end
