#!/bin/sh

cd /kafka-connect/config/

echo -e "\n ===> Creating Orders Postgres Source Connector ⏳⏳⏳"
curl -X POST -H "Content-Type: application/json" --data @connector_postgress_orders.config http://kafka-connect:8083/connectors
