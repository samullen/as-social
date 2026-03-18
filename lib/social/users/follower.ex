defmodule Social.Users.Follower do
  use Ecto.Schema
  import Ecto.Changeset

  alias Social.Users.User

  schema "followers" do
    belongs_to :follower, User, foreign_key: :follower_id

    belongs_to :followed, User, foreign_key: :followed_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(follower, attrs) do
    follower
    |> cast(attrs, [:follower_id, :followed_id])
    |> validate_required([:follower_id, :followed_id])
  end
end
