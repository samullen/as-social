defmodule Social.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Social.Repo

  alias Social.Users.User
  alias Social.Users.Follower

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def follow(%User{id: follower_id}, %User{id: followed_id}) do
    %Follower{}
    |> Follower.changeset(%{follower_id: follower_id, followed_id: followed_id})
    |> Repo.insert()
  end

  @doc """
  Gets a single user by username.

  Raises `Ecto.NoResultsError` if the User does not exist.
  """
  def get_user_by_username!(username) do
    Repo.get_by!(User, username: username)
  end

  @doc """
  Lists followers for a user with their following information.
  Returns followers ordered by inserted_at.
  """
  def list_user_followers(user_id) do
    from(f in Follower,
      where: f.followed_id == ^user_id,
      join: follower in assoc(f, :follower),
      order_by: [asc: f.inserted_at],
      preload: [follower: follower]
    )
    |> Repo.all()
  end

  @doc """
  Lists users that a user is following.
  Returns followed users ordered by inserted_at.
  """
  def list_user_following(user_id) do
    from(f in Follower,
      where: f.follower_id == ^user_id,
      join: followed in assoc(f, :followed),
      order_by: [asc: f.inserted_at],
      preload: [followed: followed]
    )
    |> Repo.all()
  end

  @doc """
  Gets follower and following counts for a user.
  """
  def get_user_follow_counts(user_id) do
    follower_count =
      from(f in Follower,
        where: f.followed_id == ^user_id,
        select: count(f.id)
      )
      |> Repo.one()

    following_count =
      from(f in Follower,
        where: f.follower_id == ^user_id,
        select: count(f.id)
      )
      |> Repo.one()

    %{followers: follower_count, following: following_count}
  end
end
