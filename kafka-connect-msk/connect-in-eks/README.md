- Create namespace for kafka  
  `kubectl create namespace kafka`  
  
- Download and install `strimzi-cluster-operator` from https://github.com/strimzi/strimzi-kafka-operator/releases  
  `kubectl apply -f strimzi-cluster-operator-0.20.1.yaml -n kafka`

- ERROR : Cluster Operator verticle in namespace kafka failed to start
io.fabric8.kubernetes.client.KubernetesClientException: kafkas.kafka.strimzi.io is forbidden: User "system:serviceaccount:kafka:strimzi-cluster-operator" cannot watch resource "kafkas" in API group "kafka.strimzi.io" in the namespace "kafka"

- SOLUTION : https://github.com/strimzi/strimzi-kafka-operator/issues/1292

```
kubectl create clusterrolebinding strimzi-cluster-operator-namespaced --clusterrole=strimzi-cluster-operator-namespaced --serviceaccount kafka:strimzi-cluster-operator

kubectl create clusterrolebinding strimzi-cluster-operator-entity-operator-delegation --clusterrole=strimzi-entity-operator --serviceaccount kafka:strimzi-cluster-operator

kubectl create clusterrolebinding strimzi-cluster-operator-topic-operator-delegation --clusterrole=strimzi-topic-operator --serviceaccount kafka:strimzi-cluster-operator
```

- Verify the cluster-operator  
  `kubectl get pods -n kafka`

  `kubectl get pods -l=name=strimzi-cluster-operator -n kafka`

- Verify the Custom Resource Definitions  
  `kubectl get crd | grep strimzi`

- Verify the Cluster Roles
  `kubectl get clusterrole | grep strimzi`

- Create the docker image after adding required connectors
`./build-docker-image.sh entechlog 2`

- Create secrets for connectors  
  `kubectl -n kafka create secret generic connect-secrets --from-file=connect-secrets.properties`

- Verify secrets 
  `kubectl get secrets connect-secrets -o yaml -n kafka`

- Create the connect cluster
  `kubectl apply -f kafka-connect-custom-image.yaml -n kafka`

- Verify the connect cluster  
  `kubectl get kafkaconnects -n kafka`

- Verify the connect cluster status
  `kubectl get kafkaconnect strimzi-connect-cluster-custom-image -o yaml -n kafka`

- Verify the connect cluster pod  
  `kubectl get pod -l=strimzi.io/cluster=strimzi-connect-cluster-custom-image -n kafka -n kafka`

- Verify the pod logs
  `kubectl logs <pod-name>`

- Deploy the connectors in connect cluster
  `kubectl apply -f twitter-source-connector.yaml -n kafka`
  
  `kubectl apply -f snowflake-sink-connector.yaml -n kafka`

- Verify the connectors
  `kubectl get kafkaconnectors -n kafka`

  `kubectl get kafkaconnectors my-favorite-celebrities-src-twitter -o yaml -n kafka`  

  `kubectl get kafkaconnectors my-favorite-celebrities-sink-snowflake -o yaml -n kafka`  

## Reference

- https://strimzi.io/blog/2020/01/27/deploying-debezium-with-kafkaconnector-resource/
- https://github.com/strimzi/strimzi-kafka-operator/blob/master/examples/connect/
- https://itnext.io/kafka-connect-on-kubernetes-the-easy-way-b5b617b7d5e9
- https://medium.com/htc-research-engineering-blog/setup-local-docker-repository-for-local-kubernetes-cluster-354f0730ed3a

