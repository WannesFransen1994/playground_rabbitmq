defmodule RabbitChat.Repo.Migrations.CreateChatters do
  use Ecto.Migration

  def change do
    create table(:chatters) do
      add :name, :string

      timestamps()
    end
  end
end
