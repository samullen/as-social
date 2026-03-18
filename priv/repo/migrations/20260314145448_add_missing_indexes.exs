defmodule Social.Repo.Migrations.AddMissingIndexes do
  use Ecto.Migration

  def change do
    create index(:posts, [:user_id])
    create index(:posts, [:inserted_at])
    create index(:followers, [:follower_id])
    create index(:followers, [:followed_id])
    create index(:followers, [:inserted_at])
  end
end
