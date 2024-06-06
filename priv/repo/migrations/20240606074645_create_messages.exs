defmodule LoadTests.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :chat_id, :integer
      add :message, :string

      timestamps(type: :utc_datetime)
    end
  end
end
