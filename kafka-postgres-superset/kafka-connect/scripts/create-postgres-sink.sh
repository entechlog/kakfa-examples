#!/bin/sh

cd /kafka-connect/config/

echo -e "\n ===> Creating users Postgres Source Connector ⏳⏳⏳"
curl -X POST -H "Content-Type: application/json" --data @connector_postgress_users.config http://kafka-connect:8083/connectors
