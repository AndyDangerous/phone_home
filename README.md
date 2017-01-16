# PhoneHome

# ToDo

* create simple (C vs. CRUD?) web interface to get data into our app
* Use the DB?
* on Create, pass info to Elixir/OTP app that will handle the things
* build out API pipeline for twilio integration
* Determine appropriate seams/protocols for communication between web app and Elixir App

# Elixir/OTP App needs:

* Figure out OTP Architecture
  * Supervision Tree
  * Process communication streams
* handle timing (ets table and some sort of chron job?)
* build note state machine (GenServer that tracks state of note?)




To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
