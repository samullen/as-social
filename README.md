# Social

## Performance Issues

- No `user_id` index on `posts`
- No index on `followers.inserted_at`
  - Used if you want to know when someone started following you
- N+1 queries
  - Maybe do this with the counts
  - Fix: use a joins/preload
  - This will lead to unbound queries and issues with indexes
- Unbound queries
  - Return all posts for all followeds
  - fix is to add a `limit()`
