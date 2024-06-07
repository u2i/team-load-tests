defmodule LoadTests.Timeline.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :username, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:username, :body])
    |> validate_required([:username, :body])
    |> validate_length(:username, min: 3, max: 50)
    |> validate_length(:body, min: 3, max: 140)
  end
end
