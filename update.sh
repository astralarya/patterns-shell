#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )" &&
ref="$(git rev-parse --abbrev-ref HEAD)" &&
if [ "$ref" = HEAD ]
then ref="$(git rev-parse HEAD)"
elif [ "$ref" = master ]
then ref=""
fi &&
git pull &&
git submodule update --recursive --init &&
if [ "$ref" ]
then git checkout "$ref"
fi
