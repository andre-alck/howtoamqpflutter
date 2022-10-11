import "dart:io";
import "package:dart_amqp/dart_amqp.dart";

void main() {
  Client client = Client();

  // Verifica se o usuário finalizou o programa.
  ProcessSignal.sigint.watch().listen(
    (
      _,
    ) {
      client.close().then(
        (
          _,
        ) {
          print(
            "close client",
          );
          exit(
            0,
          );
        },
      );
    },
  );

  // 0 inclusivo, 2 exclusivo. routingKeys = primeiro e segundo argumento.
  List<String> routingKeys = [
    'info',
  ];

  client.channel().then(
    (
      Channel channel,
    ) {
      return channel.exchange(
        "direct_logs",
        ExchangeType.DIRECT,
        durable: false,
      );
    },
  ).then(
    (
      Exchange exchange,
    ) {
      print(
        " [*] Waiting for messages in logs. To Exit press CTRL+C",
      );
      return exchange.bindPrivateQueueConsumer(
        routingKeys,
        consumerTag: "direct_logs",
        noAck: true,
      );
    },
  ).then(
    (
      Consumer consumer,
    ) {
      consumer.listen(
        (
          AmqpMessage event,
        ) {
          print(
            " [x] ${event.routingKey}:'${event.payloadAsString}'",
          );
        },
      );
    },
  );
}
