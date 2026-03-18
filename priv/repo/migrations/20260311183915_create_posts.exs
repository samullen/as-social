defmodule Social.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :title, :string, null: false
      add :content, :text, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
