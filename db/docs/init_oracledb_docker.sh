#!/bin/bash
# docker login container-registry.oracle.com

# --- Configurable Environment Variables ---
CONTAINER_NAME="oracle-db-test-car-rental"
IMAGE_NAME="container-registry.oracle.com/database/enterprise:latest"
DOCKER_VOLUME_NAME="oracle-db-test-car-rental-data"

# Oracle Database Settings
ORACLE_PASSWORD="Thien55555="
ORACLE_SID="ORCL"
ORACLE_PDB="ORCLPDB1"

# --- Create volume directory if it doesn't exist ---
if [ "$(docker volume ls -q -f name=$DOCKER_VOLUME_NAME)" = "" ]; then
  echo "Creating Docker volume: $DOCKER_VOLUME_NAME"
  docker volume create "$DOCKER_VOLUME_NAME"
else
  echo "Docker volume $DOCKER_VOLUME_NAME already exists."
fi

# --- Remove existing container if present ---
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
  echo "Existing container '$CONTAINER_NAME' found. Removing it..."
  docker rm -f "$CONTAINER_NAME"
fi

# --- Run Oracle container with volume and resource limits ---
docker run -d \
  --name "$CONTAINER_NAME" \
  -p 1521:1521 -p 5500:5500 \
  -e ORACLE_SID="$ORACLE_SID" \
  -e ORACLE_PDB="$ORACLE_PDB" \
  -e ORACLE_PWD="$ORACLE_PASSWORD" \
  -v "$DOCKER_VOLUME_NAME":/opt/oracle/oracdata \
  "$IMAGE_NAME"

echo "Oracle container '$CONTAINER_NAME' has been started with the following configuration:"
echo "- Docker volume: $DOCKER_VOLUME_NAME"
echo "- ORACLE_SID: $ORACLE_SID"
echo "- ORACLE_PDB: $ORACLE_PDB"
echo "- SYS/SYSTEM password: $ORACLE_PASSWORD"
