import Mix.Config

amqp_connection_options = [
  host: "3.67.177.249",
  port: 5672,
  virtual_host: "/",
  username: "testuser",
  password: "7HDpJ23ntECiR6bx"
]

config :amqp,
  connections: [
    hello_tcp_connection: amqp_connection_options,
    world_tcp_connection: amqp_connection_options
  ],
  channels: [
    hello_produce_channel: [connection: :hello_tcp_connection],
    world_consume_channel: [connection: :world_tcp_connection]
  ]
