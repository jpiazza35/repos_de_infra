#!/bin/bash
cd src
find . -type d -exec touch {}/__init__.py \;
cd -
echo "Empty __init__.py files added to all directories."
