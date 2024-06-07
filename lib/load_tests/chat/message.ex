defmodule LoadTests.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :message, :string
    field :chat_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:chat_id, :message])
    |> validate_required([:chat_id, :message])
    |> validate_length(:message, min: 2, max: 160)
  end
end
