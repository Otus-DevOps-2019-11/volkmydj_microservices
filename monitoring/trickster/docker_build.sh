#!/bin/bash
set -eu

docker build -t $USER_NAME/trickster:${VERSION} .