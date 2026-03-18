# Social

This is an example app used for writing articles for AppSignal. It really
doesn't do much other than provide a single route to show a list of posts for a
user and who they follow or are followed by.

# Setup

The app was developed using Elixir 1.18.4 (OTP 28). It will likely run on other
versions, but I haven't tested that.

## Step 1 - .env

You will need to create a `.env` file in the root of the project. In there, you
will add you AppSignal API key. It will look like this:

```
APPSIGNAL_KEY="00000000-0000-0000-0000-000000000000"
```

## Step 2 - Dependencies

Run `mix deps.get` from the project directory

## Step 3 - Database

This still will create, migrate, and seed the database

```unix
mix ecto.setup
```

## Step 4 - Running the app

Just like all (okay, most) Phoenix applications, you can start it with the usual
command:

```unix
mix phx.server
```

# Articles referencing this project

- [Debugging Slow Ecto Queries with AppSignal]() - _Unpublished_
