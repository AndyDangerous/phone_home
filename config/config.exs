# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phone_home,
  ecto_repos: [PhoneHome.Repo]

# Configures the endpoint
config :phone_home, PhoneHome.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DaMkE8A0BFWWiOdNoj3/SZqu0ZxP6XEtzfOd9cYsSS0C9Pnqn0DztZh9TD3oZNNY",
  render_errors: [view: PhoneHome.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoneHome.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Run the check the timer once/minute
config :quantum, cron: [
    "* * * * *":      {"PhoneHome.NoteServer", :check_timer},
]
