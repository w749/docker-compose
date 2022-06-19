# topic
docker-compose exec kafka /opt/kafka_2.13-2.8.1/bin/kafka-topics.sh --bootstrap-server kafka:9092

# consumer
docker-compose exec kafka /opt/kafka_2.13-2.8.1/bin/kafka-console-consumer.sh --bootstrap-server kafka:9092

# producer
docker-compose exec kafka /opt/kafka_2.13-2.8.1/bin/kafka-console-producer.sh --broker-list kafka:9092
