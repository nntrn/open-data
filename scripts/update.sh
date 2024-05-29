#!/usr/bin/env bash

set -e

SCRIPT="$(realpath $0)"
DIR=${SCRIPT%/*/*}

CATALOG_URL='https://api.us.socrata.com/api/catalog/v1?only=dataset&limit=2000'

while [ $# -gt 0 ]; do
  case $1 in
  -f | --fetch) RUN_FETCH=1 ;;
  esac
  shift || break
done

download_if() {
  if [[ $RUN_FETCH -eq 1 ]] || [[ ! -f $1 ]]; then
    curl --create-dirs -o $1 "$2"
  fi
}

download_if data/texas-gov.json "${CATALOG_URL}&domains=data.texas.gov"
download_if data/texas.json "${CATALOG_URL}&q=texas"
download_if data/austin.json "${CATALOG_URL}&domains=datahub.austintexas.gov"
download_if data/crime.json "${CATALOG_URL}&q=crime"
download_if data/datasets.json "${CATALOG_URL}&q=datasets"

$DIR/scripts/markdown.sh data/texas-gov.json -Y >texas-gov.md
$DIR/scripts/markdown.sh data/texas.json -Y >texas.md
$DIR/scripts/markdown.sh data/austin.json -Y >austin.md
$DIR/scripts/markdown.sh data/crime.json -Y >crime.md
$DIR/scripts/markdown.sh data/datasets.json -Y >datasets.md
