defmodule Social.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Social.Users.Follower

  schema "users" do
    has_many :followers, Follower, foreign_key: :followed_id

    has_many :follows, Follower, foreign_key: :follower_id

    field :username, :string
    field :email, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
  end
end
