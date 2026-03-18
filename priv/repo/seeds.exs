# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Social.Repo.insert!(%Social.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Social.Users
alias Social.Posts

{:ok, alice} = Users.create_user(%{username: "alice", email: "alice@soshul.io"})
{:ok, bob} = Users.create_user(%{username: "bob", email: "bob@soshul.io"})
{:ok, charlie} = Users.create_user(%{username: "charlie", email: "charlie@soshul.io"})
{:ok, dave} = Users.create_user(%{username: "dave", email: "dave@soshul.io"})

Users.follow(alice, bob)
Users.follow(alice, charlie)
Users.follow(alice, dave)
Users.follow(bob, charlie)
Users.follow(charlie, dave)
Users.follow(dave, alice)

Enum.each(1..500, fn i ->
  Posts.create_post(%{user_id: alice.id, title: "Alice's post #{i}", content: "Lorem ipsum dolor. Post number #{i}."})
  Process.sleep(10) # Ensure different timestamps for posts
  Posts.create_post(%{user_id: bob.id, title: "Bob's post #{i}", content: "Lorem ipsum dolor. Post number #{i}."})
  Process.sleep(10) # Ensure different timestamps for posts
  Posts.create_post(%{user_id: charlie.id, title: "Charlie's post #{i}", content: "Lorem ipsum dolor. Post number #{i}."})
  Process.sleep(10) # Ensure different timestamps for posts
  Posts.create_post(%{user_id: dave.id, title: "Dave's post #{i}", content: "Lorem ipsum dolor. Post number #{i}."})
  Process.sleep(10) # Ensure different timestamps for posts
end)
