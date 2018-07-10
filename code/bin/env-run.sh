#!/usr/bin/env bash

env="$1"
cmd="$2"

if [[ "$LOCAL_ENV" == "$env" ]]; then
    $cmd
else
    echo "Wrong local env: $LOCAL_ENV"
    echo "Expected local env: $env"
fi
