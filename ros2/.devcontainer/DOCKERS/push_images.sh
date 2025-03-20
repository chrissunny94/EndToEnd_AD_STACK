#!/bin/bash

USERNAME="christhaliyath"

echo "Logging in to Docker Hub..."
docker login -u "$USERNAME"

IMAGES=("base" "ros" "tensorrt" "pytorch" "final")

for IMAGE in "${IMAGES[@]}"; do
    echo "Building $IMAGE..."
    docker build -t "$USERNAME/$IMAGE:latest" -f "Dockerfile.$IMAGE" .

    echo "Pushing $IMAGE..."
    docker push "$USERNAME/$IMAGE:latest"
done

echo "✅ All images pushed successfully!"
