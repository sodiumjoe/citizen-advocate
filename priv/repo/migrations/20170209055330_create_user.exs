defmodule Action.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
    end
  end
end
