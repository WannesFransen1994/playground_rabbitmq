defmodule RabbitCode.HelloWorld.HelloWorldSupervisor do
  # Automatically defines child_spec/1
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      RabbitCode.HelloWorld.HelloPublisher,
      RabbitCode.HelloWorld.WorldConsumer,
      RabbitCode.HelloWorld.AnnoyingHello
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

# Enum.each(1..10_000, fn _ -> RabbitCode.HelloWorld.HelloPublisher.publish_hello end)
