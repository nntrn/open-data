#!/usr/bin/env bash

# Used to create index.txt

set -e

SCRIPT="$(realpath $0)"
DIR=${SCRIPT%/*/*}

grep -B 1 -roEih '\[Data\]\([^ ]*\)' ${DIR:-.}/catalog/*.md |
  tr '\n' ' ' |
  sed 's,-- - ,\n- ,g' |
  sort -u -t ']' -k 2 |
  awk -F '[' '{ gsub(/[\[\]\(\)\*]+|Data/, ""); print }' |
  awk -v OFS='\t' -F '   ' '{print $2, $1}' |
  sed 's,^[ ]*,,g' |
  tee ${DIR:-.}/index.txt
