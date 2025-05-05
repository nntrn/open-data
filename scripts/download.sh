#!/usr/bin/env bash

SCRIPT="$(realpath $0)"
DIR=${SCRIPT%/*/*}

TOCPATH=$DIR/_data/toc.json

if [[ -f $DIR/data ]]; then
  echo "Deleting..."
  find $DIR/data -type f -name "*.json" -print -delete
fi

if [[ -f $TOCPATH ]]; then
  echo "Downloading..."
  jq -r 'map(["url = \(.url)","output = data/\(.title).json"]|join("\n"))[]' $TOCPATH |
    curl -Z -K - --create-dirs
fi
