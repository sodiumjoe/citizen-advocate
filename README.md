# CitizenAdvocate

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate` <sup>[1](#postgres)</sup>
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

<span id='postgres'>1.</span> This assumes you have postgres running locally. On MacOS:

```bash
# If you have docker
docker run -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres

# or

brew install postgres
pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
createuser -d postgres
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
