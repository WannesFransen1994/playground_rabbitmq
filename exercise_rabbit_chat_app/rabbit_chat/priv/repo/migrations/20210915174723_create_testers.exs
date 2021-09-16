defmodule RabbitChat.Repo.Migrations.CreateTesters do
  use Ecto.Migration

  def change do
    create table(:testers) do
      add :name, :string

      timestamps()
    end
  end
end
