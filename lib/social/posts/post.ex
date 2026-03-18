defmodule Social.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Social.Users.User

  schema "posts" do
    belongs_to :user, User

    field :title, :string
    field :content, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:user_id, :title, :content])
    |> validate_required([:user_id, :title, :content])
  end
end
