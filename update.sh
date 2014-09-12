#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )" &&
git pull &&
git submodule update --recursive --init
