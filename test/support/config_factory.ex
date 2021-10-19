defmodule ExAwsConfigurator.Factory.Config do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      def config_factory do
        %{
          account_id: "000000000000",
          queues: build(:queue_config),
          topics: build(:topic_config)
        }
      end

      def queue_config_factory(attrs) do
        name = Map.get(attrs, :name, :an_queue)
        raw_message_delivery = Map.get(attrs, :raw_message_delivery, false)
        dead_letter_queue = Map.get(attrs, :dead_letter_queue, true)
        fifo_queue = Map.get(attrs, :fifo_queue, false)

        queue_config =
          %{
            environment: "test",
            prefix: "prefix",
            region: "us-east-1",
            options: [
              raw_message_delivery: raw_message_delivery,
              dead_letter_queue: dead_letter_queue
            ],
            attributes: [
              fifo_queue: fifo_queue
            ],
            topics: []
          }
          |> merge_attributes(attrs)
          |> Map.delete(:name)

        %{name => queue_config}
      end

      def topic_config_factory(attrs) do
        name = Map.get(attrs, :name, :an_topic)

        topic_config =
          %{
            environment: "test",
            prefix: "prefix",
            region: "us-east-1"
          }
          |> merge_attributes(attrs)
          |> Map.delete(:name)

        %{name => topic_config}
      end
    end
  end
end
