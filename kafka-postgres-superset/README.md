## Kafka Superset

- Start the containers by running `docker-compose up --remove-orphans -d --build`
- Navigate to control center in `http://<your-host-name>:9021/clusters`
- Config files for this example was sourced from https://github.com/confluentinc/kafka-connect-datagen/tree/master/config
- Bring down the containers by running `docker-compose down --volumes`
- Delete exited containers by running `docker rm $(docker ps -q -f status=exited)`

## Reference 
- https://kb.objectrocket.com/postgresql/how-to-create-postgresql-test-data-1138
- https://gist.github.com/onjin/2dd3cc52ef79069de1faa2dfd456c945
- https://rmoff.net/2017/09/06/kafka-connect-jsondeserializer-with-schemas.enable-requires-schema-and-payload-fields/