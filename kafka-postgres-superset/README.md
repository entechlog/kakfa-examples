## Kafka Superset

- Start the containers by running `docker-compose up --remove-orphans -d --build`
- Navigate to control center in `http://<your-host-name>:9021/clusters`
- Config files for this example was sourced from https://github.com/confluentinc/kafka-connect-datagen/tree/master/config
- Bring down the containers by running `docker-compose down --volumes`
- Delete exited containers by running `docker rm $(docker ps -q -f status=exited)`