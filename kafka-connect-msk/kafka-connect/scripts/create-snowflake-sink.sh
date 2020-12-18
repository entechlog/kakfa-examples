#!/bin/sh

curl -i -X PUT -H  "Content-Type:application/json" \
    http://kafka-connect:8083/connectors/MY_FAVORITE_CELEBRITIES_SINK_SNOWFLAKE/config \
    -d '{
        "connector.class":"com.snowflake.kafka.connector.SnowflakeSinkConnector",
        "tasks.max":1,
        "topics":"twitter.my.favorite.celebrities.src",
        "snowflake.url.name":"${file:/opt/confluent/secrets/connect-secrets.properties:SNOWFLAKE_HOST}",
        "snowflake.user.name":"${file:/opt/confluent/secrets/connect-secrets.properties:SNOWFLAKE_USER}",
        "snowflake.user.role":"SYSADMIN",
        "snowflake.private.key":"${file:/opt/confluent/secrets/connect-secrets.properties:SNOWFLAKE_PRIVATE_KEY}",
        "snowflake.database.name":"DEMO_DB",
        "snowflake.schema.name":"PUBLIC",
        "key.converter":"org.apache.kafka.connect.storage.StringConverter",
        "value.converter.schemas.enable": "false",
        "value.converter":"org.apache.kafka.connect.json.JsonConverter"
    }'
