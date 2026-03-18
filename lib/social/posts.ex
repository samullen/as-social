defmodule Social.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Social.Repo

  alias Social.Posts.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  @doc """
  Lists posts from users that the given user follows.
  Returns posts ordered by inserted_at descending (newest first).
  """
  def list_feed_posts(user_id, page \\ 1, page_size \\ 20) do
    from(p in Post,
      join: f in Social.Users.Follower,
      on: f.follower_id == ^user_id and f.followed_id == p.user_id,
      join: u in assoc(p, :user),
      order_by: [desc: p.inserted_at],
      preload: [user: u],
      limit: ^page_size,
      offset: ^((page - 1) * page_size)
    )
    |> Repo.all()
  end

  @doc """
  Lists posts from users that the given user follows.
  Returns posts ordered by inserted_at descending (newest first).

  This is intentionally implemented as an N+1 query for demonstration purposes:
  1. First query: Get all users that user_id follows
  2. N queries: Get posts for each followed user (one query per user)
  3. Merge and sort all posts in memory
  """
  def slow_list_feed_posts(user_id) do
    # First query: Get all followed user IDs
    followed_user_ids =
      from(f in Social.Users.Follower,
        where: f.follower_id == ^user_id,
        select: f.followed_id
      )
      |> Repo.all()

    # N+1 queries: Get posts for each followed user (one query per user)
    all_posts =
      Enum.flat_map(followed_user_ids, fn followed_id ->
        from(p in Post,
          where: p.user_id == ^followed_id,
          join: u in assoc(p, :user),
          preload: [user: u]
        )
        |> Repo.all()
      end)

    # Sort all posts by inserted_at descending
    Enum.sort_by(all_posts, & &1.inserted_at, {:desc, DateTime})
  end
end
