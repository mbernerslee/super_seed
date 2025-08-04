#!/usr/bin/env bash

if [ -z "$(docker compose ps -q)" ]; then
  echo "Starting docker compose..."
  docker compose up -d
else
  echo "Docker compose already running"
fi

