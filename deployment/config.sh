#!/bin/bash

BRANCH_NAME="$(git rev-parse --abbrev-ref HEAD)"

if [[ "$BRANCH_NAME" == "master" ]]; then
    echo "Cannot deploy/delete from within master"
    exit 1
fi

STAGE=${BRANCH_NAME//[_\/]/-}
