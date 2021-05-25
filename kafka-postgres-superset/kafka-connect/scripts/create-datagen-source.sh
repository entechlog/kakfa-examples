#!/bin/sh

cd /kafka-connect/config/

curl -X POST -H "Content-Type: application/json" --data @connector_orders.config http://kafka-connect:8083/connectors
