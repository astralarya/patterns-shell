#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )" &&
ref="$(git symbolic-ref --short --quiet HEAD || git rev-parse HEAD)" &&
if [ "$ref" = master ]
then ref=""
else git checkout master
fi &&
git pull &&
git submodule update --recursive --init &&
if [ "$ref" ]
then git checkout "$ref"
fi
