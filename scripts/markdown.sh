#!/usr/bin/env bash

SCRIPT="$(realpath $0)"
DIR=${SCRIPT%/*}
# CACHE_DIR=$HOME/.cache/atx

export MARKDOWN_TITLE=
export MARKDOWN_EXCLUDE=

_exclude=(
  BOUNDARIES
  PLANNINGCADASTRE
  UTILITIESCOMMUNICATION
  GEOSCIENTIFICINFORMATION
  GUIDE
  TRANSPORTATION
  Test
  TEST
  deprecated
)

join_by() {
  local IFS="$1"
  shift
  echo "$*"
}

_chksum() {
  cksum <<<$1 | awk '{print $1}'
}

while [ $# -gt 0 ]; do
  case $1 in
  -t | --title) MARKDOWN_TITLE="$2" && shift ;;
  -e | --exclude) MARKDOWN_EXCLUDE="$2" && shift ;;
  -a | --all) MARKDOWN_EXCLUDE="" ;;
  -Y | --exclude-year) _exclude+=("[2][0-2][0-3][0-9]" "FY[0-2][0-9]") ;;

  *\.json) MARKDOWN_INPUT=$1 ;;
  esac
  shift || break
done

if [[ -z $MARKDOWN_TITLE ]]; then
  MARKDOWN_TITLE="${MARKDOWN_INPUT##*/}"
  MARKDOWN_TITLE="${MARKDOWN_TITLE%%.*}"
  MARKDOWN_TITLE="${MARKDOWN_TITLE^}"
fi

MARKDOWN_EXCLUDE="$(join_by '|' "${_exclude[@]}")"

$DIR/catalog.sh $MARKDOWN_INPUT --simple --markdown .classification
