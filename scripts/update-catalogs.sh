#!/usr/bin/env bash

set -e

SCRIPT="$(realpath $0)"
DIR=${SCRIPT%/*/*}
OUTDIR=${OUTDIR:-$1}

DOCDIR=${DOCDIR:-$2}
CATALOG_URL='https://api.us.socrata.com/api/catalog/v1?only=dataset&limit=10000'
FORCE=${FORCE:-0}

_pids=()

if [[ -z $OUTDIR ]]; then
  OUTDIR=$(mktemp -d)
fi

if [[ -z $DOCDIR ]]; then
  DOCDIR=.
fi

mkdir -p $OUTDIR
mkdir -p $DOCDIR

download_data() {
  local data_out="$OUTDIR/${1}.json"
  local doc_out="$DOCDIR/${1}.md"
  local catalog_url="$2"

  if [[ ! -f $data_out ]]; then
    curl -s --create-dirs -o $data_out "$catalog_url" --fail
    _pids+=("$!")
  fi

  echo -e "$doc_out\t$catalog_url"

  jq -L $DIR/scripts -r \
    --arg catalog "$catalog_url" \
    --arg group "${3:-category}" \
    'include "views"; results|write_markdown($group)' \
    $data_out >$doc_out

  _pids+=("$!")
}

download_data texas-gov "${CATALOG_URL}&domains=data.texas.gov" category &
download_data texas "${CATALOG_URL}&q=texas" domain &
download_data austin "${CATALOG_URL}&domains=datahub.austintexas.gov" category &
download_data crime "${CATALOG_URL}&q=crime" domain &
download_data datasets "${CATALOG_URL}&q=datasets" domain &
download_data shootings "${CATALOG_URL}&q=shooting" domain &
download_data police "${CATALOG_URL}&q=police" domain &
download_data salaries "${CATALOG_URL}&q=salaries" domain &
download_data jobs "${CATALOG_URL}&q=jobs" domain &
download_data survey "${CATALOG_URL}&q=survey" domain &
download_data public-safety "${CATALOG_URL}&categories=public%20safety" category

wait "${_pids[@]}"

wait -n
