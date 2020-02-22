#!/bin/bash
CONTAINER_NAME="gitlab-reddit-gitlab-*"
OLD="$(docker ps --all --quiet --filter=name="$CONTAINER_NAME")"
if [ -n "$OLD" ]; then
  echo "Container running" && docker stop $OLD
fi
