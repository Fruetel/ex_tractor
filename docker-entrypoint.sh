#!/bin/bash

if [ "$1" == "test" ]; then
    export MIX_ENV=test
    mix test
elif [ "$1" == "local" ]; then
    export MIX_ENV=prod
    mix run --no-halt
else
    export MIX_ENV=prod
    mix run --no-halt
fi
