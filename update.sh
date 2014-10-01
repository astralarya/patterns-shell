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
git merge --strategy=recursive --strategy-option=ours master &&
(git merge --abort 2>/dev/null && printf 'Auto merge failed with master\n' ||
  true)
fi &&
printf 'Update complete\n'
