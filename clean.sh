#!/bin/sh
set -e
set -u

cd "$(dirname "$0")/buildroot"
make distclean
