#!/bin/sh

cmake . -B wsl-build
wait
make -C wsl-build --no-print-directory -j4
wait