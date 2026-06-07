#!/bin/bash
echo "Creating application namespace..."
kubectl create namespace retail-app --dry-run=client -o yaml | kubectl apply -f -

echo "Creating MySQL Database Credentials Secret..."
kubectl create secret generic retail-db-credentials \
  --namespace retail-app \
  --from-literal=username=admin \
  --from-literal=password="SecurePass123!" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "Creating PostgreSQL Database Credentials Secret..."
kubectl create secret generic retail-postgres-credentials \
  --namespace retail-app \
  --from-literal=username=postgres \
  --from-literal=password="SecurePassPostgres123!" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "Deploying Application via OCI Helm Registry with AWS data layer overrides..."
helm upgrade --install retail-store oci://public.ecr.aws/aws-containers/retail-store-sample-chart \
  --version 0.8.5 \
  --namespace retail-app \
  --set catalog.mysql.enabled=false \
  --set orders.postgres.enabled=false \
  --set carts.dynamodb.enabled=false \
  -f values.yaml
