import Config

config :chifoumi, Chifoumi.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "chifoumi",
  password: "chifoumi",
  database: "chifoumi_eventstore_test",
  hostname: "localhost",
  pool_size: 10


config :logger, level: :warn
