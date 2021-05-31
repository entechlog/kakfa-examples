#!/bin/sh

cd /kafka-connect/config/

echo -e "\n ===> Creating Orders Datagen Source Connector ⏳⏳⏳"
curl -X POST -H "Content-Type: application/json" --data @connector_datagen_orders.config http://kafka-connect:8083/connectors
