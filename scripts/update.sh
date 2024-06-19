#!/usr/bin/env bash

set -e

SCRIPT="$(realpath $0)"
DIR=${SCRIPT%/*/*}
OUTDIR=${OUTDIR:-$1}
CATALOG_URL='https://api.us.socrata.com/api/catalog/v1?only=dataset&limit=10000'

_pids=()

if [[ -z $OUTDIR ]]; then
  OUTDIR=$(mktemp -d)
fi
if [[ ! -d $OUTDIR ]]; then
  mkdir -p $OUTDIR
fi

download_if() {
  if [[ ! -f $1 ]]; then
    curl -s --create-dirs -o $1 "$2" --fail
    _pids+=("$!")
  fi
  $DIR/scripts/markdown.sh $1 $3
  _pids+=("$!")
}

download_if $OUTDIR/texas-gov.json "${CATALOG_URL}&domains=data.texas.gov" -Y >texas-gov.md &
download_if $OUTDIR/texas.json "${CATALOG_URL}&q=texas" "-Y --group .domain" >texas.md &
download_if $OUTDIR/austin.json "${CATALOG_URL}&domains=datahub.austintexas.gov" >austin.md &
download_if $OUTDIR/crime.json "${CATALOG_URL}&q=crime" "-Y --group .domain" >crime.md &
download_if $OUTDIR/datasets.json "${CATALOG_URL}&q=datasets" "-Y --group .domain" >datasets.md &
download_if $OUTDIR/shootings.json "${CATALOG_URL}&q=shooting" "-Y --group .domain" >shootings.md &
download_if $OUTDIR/police.json "${CATALOG_URL}&q=police" "-Y --group .domain" >police.md &
download_if $OUTDIR/salaries.json "${CATALOG_URL}&q=salaries" "-Y --group .domain" >salaries.md &
download_if $OUTDIR/jobs.json "${CATALOG_URL}&q=jobs" "-Y --group .domain" >jobs.md

wait "${_pids[@]}"
