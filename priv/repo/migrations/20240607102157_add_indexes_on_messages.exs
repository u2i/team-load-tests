defmodule LoadTests.Repo.Migrations.AddIndexesOnMessages do
  use Ecto.Migration

  def change do
    create index(:messages, [:chat_id])
  end
end
