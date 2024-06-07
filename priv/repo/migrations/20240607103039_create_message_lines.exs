defmodule LoadTests.Repo.Migrations.CreateMessageLines do
  use Ecto.Migration

  def change do
    create table(:message_lines) do
      add :conversation_id, :integer, index: true
      add :body, :string

      timestamps(type: :utc_datetime)
    end
  end
end
