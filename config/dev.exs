import Config

config :chifoumi, Chifoumi.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "chifoumi",
  password: "chifoumi",
  database: "chifoumi_eventstore_dev",
  hostname: "localhost",
  pool_size: 10

config :mix_test_watch,
  clear: true
