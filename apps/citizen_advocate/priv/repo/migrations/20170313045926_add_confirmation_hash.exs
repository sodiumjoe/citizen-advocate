defmodule CitizenAdvocate.Repo.Migrations.AddConfirmationHash do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :confirmed_at, :utc_datetime
      add :hashed_confirmation_token, :string
    end
  end
end
