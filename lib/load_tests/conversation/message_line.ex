defmodule LoadTests.Conversation.MessageLine do
  use Ecto.Schema
  import Ecto.Changeset

  schema "message_lines" do
    field :body, :string
    field :conversation_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message_line, attrs) do
    message_line
    |> cast(attrs, [:conversation_id, :body])
    |> validate_required([:conversation_id, :body])
    |> validate_length(:body, min: 3, max: 140)
  end
end
