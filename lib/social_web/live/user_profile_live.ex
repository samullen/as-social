defmodule SocialWeb.UserProfileLive do
  use SocialWeb, :live_view

  alias Social.Users
  alias Social.Posts

  @impl true
  def mount(%{"username" => username}, _session, socket) do
    user = Users.get_user_by_username!(username)
    followers = Users.list_user_followers(user.id)
    following = Users.list_user_following(user.id)
    counts = Users.get_user_follow_counts(user.id)
    feed_posts = Posts.list_feed_posts(user.id)

    socket =
      socket
      |> assign(:user, user)
      |> assign(:followers, followers)
      |> assign(:following, following)
      |> assign(:follower_count, counts.followers)
      |> assign(:following_count, counts.following)
      |> assign(:feed_posts, feed_posts)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="max-w-6xl mx-auto px-4 py-8">
        <%!-- User Header --%>
        <div class="mb-8">
          <h1 class="text-4xl font-bold text-gray-900">{@user.username}</h1>
          <p class="text-gray-600">{@user.email}</p>
          <div class="flex gap-6 mt-4">
            <div>
              <span class="font-semibold">{@follower_count}</span>
              <span class="text-gray-600"> followers</span>
            </div>
            <div>
              <span class="font-semibold">{@following_count}</span>
              <span class="text-gray-600"> following</span>
            </div>
          </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
          <%!-- Followers/Following Section --%>
          <div class="lg:col-span-1 space-y-6">
            <%!-- Followers --%>
            <div class="bg-white rounded-lg shadow p-6">
              <h2 class="text-2xl font-bold mb-4">Followers</h2>
              <%= if @followers == [] do %>
                <p class="text-gray-500">No followers yet</p>
              <% else %>
                <ul class="space-y-3">
                  <%= for follower_relation <- @followers do %>
                    <li class="border-b border-gray-200 pb-3 last:border-0">
                      <div class="flex items-start justify-between">
                        <div>
                          <p class="font-semibold text-gray-900">
                            {follower_relation.follower.username}
                          </p>
                          <p class="text-sm text-gray-500">
                            {follower_relation.follower.email}
                          </p>
                          <p class="text-xs text-gray-400 mt-1">
                            Following since {Calendar.strftime(
                              follower_relation.inserted_at,
                              "%B %d, %Y"
                            )}
                          </p>
                        </div>
                      </div>
                    </li>
                  <% end %>
                </ul>
              <% end %>
            </div>

            <%!-- Following --%>
            <div class="bg-white rounded-lg shadow p-6">
              <h2 class="text-2xl font-bold mb-4">Following</h2>
              <%= if @following == [] do %>
                <p class="text-gray-500">Not following anyone yet</p>
              <% else %>
                <ul class="space-y-3">
                  <%= for following_relation <- @following do %>
                    <li class="border-b border-gray-200 pb-3 last:border-0">
                      <div class="flex items-start justify-between">
                        <div>
                          <p class="font-semibold text-gray-900">
                            {following_relation.followed.username}
                          </p>
                          <p class="text-sm text-gray-500">
                            {following_relation.followed.email}
                          </p>
                          <p class="text-xs text-gray-400 mt-1">
                            Following since {Calendar.strftime(
                              following_relation.inserted_at,
                              "%B %d, %Y"
                            )}
                          </p>
                        </div>
                      </div>
                    </li>
                  <% end %>
                </ul>
              <% end %>
            </div>
          </div>

          <%!-- Feed Section --%>
          <div class="lg:col-span-2">
            <div class="bg-white rounded-lg shadow p-6">
              <h2 class="text-2xl font-bold mb-4">Feed</h2>
              <%= if @feed_posts == [] do %>
                <p class="text-gray-500">
                  No posts in your feed yet. Follow some users to see their posts here!
                </p>
              <% else %>
                <div class="space-y-6">
                  <%= for post <- @feed_posts do %>
                    <article class="border-b border-gray-200 pb-6 last:border-0">
                      <div class="flex items-center mb-2">
                        <span class="font-semibold text-gray-900">{post.user.username}</span>
                        <span class="text-gray-400 mx-2">·</span>
                        <span class="text-sm text-gray-500">
                          {Calendar.strftime(post.inserted_at, "%B %d, %Y at %I:%M %p")}
                        </span>
                      </div>
                      <h3 class="text-xl font-bold text-gray-900 mb-2">{post.title}</h3>
                      <p class="text-gray-700">{post.content}</p>
                    </article>
                  <% end %>
                </div>
              <% end %>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
