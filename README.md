# Chifoumi

## Setup

Start PostgreSQL.

```
$ pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log  start
$ psql postgres
```

Add a PostgreSQL role for the app. It needs the permission to login and to create databases.

```
postgres=# CREATE ROLE chifoumi WITH PASSWORD 'chifoumi' LOGIN CREATEDB;
```

Create the database.

```
MIX_ENV=test mix do event_store.create, event_store.init
```

Run the game in a console.

```
iex -S mix
```

Run commands from the iex shell. Check all available commands in the tests.
