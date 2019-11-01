import Config

config :chifoumi, event_stores: [Chifoumi.EventStore]

config :chifoumi, Chifoumi.Application,
  event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: Chifoumi.EventStore
    ]

import_config "#{Mix.env()}.exs"
