echo "Testing Kafka"
    topic="testtopic"
    if grep -q kafka3 $1; then replication_factor="3"; else replication_factor="1"; fi
    for i in 1 2 3 4 5; do echo "trying to create test topic" && kafka-topics.sh --create --topic $topic --replication-factor $replication_factor --partitions 12 --zookeeper $DOCKER_HOST_IP:2181 && break || sleep 5; done
    for x in {1..100}; do echo $x; done | kafka-console-producer.sh --broker-list $DOCKER_HOST_IP:9092 --topic $topic
    rows=`kafka-console-consumer.sh --bootstrap-server $DOCKER_HOST_IP:9092 --topic $topic --from-beginning --timeout-ms 2000 | wc -l`
    # rows=`kafkacat.sh -C -b $DOCKER_HOST_IP:9092 -t $topic -o beginning -e | wc -l `
    if [ "$rows" != "100" ]; then
        kafka-console-consumer.sh --bootstrap-server $DOCKER_HOST_IP:9092 --topic test-topic --from-beginning --timeout-ms 2000 | wc -l
        exit 1
    else
        echo "Kafka Test Success"
fi
