#!/bin/sh

cd /kafka-connect/config/

echo -e "\n ===> Creating Orders Datagen ⏳⏳⏳"
curl -X POST -H "Content-Type: application/json" --data @connector_orders.config http://localhost:8083/connectors && break  # substitute your command here
