#!/bin/bash
set -eu

docker build -t $USER_NAME/stackdriver:${VERSION} .