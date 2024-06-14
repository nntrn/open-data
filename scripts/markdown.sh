#!/usr/bin/env bash

SCRIPT="$(realpath $0)"
DIR=${SCRIPT%/*}
# CACHE_DIR=$HOME/.cache/atx

export MARKDOWN_TITLE=
export MARKDOWN_EXCLUDE=
export MARKDOWN_INPUT=()
export MARKDOWN_GROUP=.classification

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
  "Demo "
  "DEMO "
)

join_by() {
  local IFS="$1"
  shift
  echo "$*"
}

_chksum() {
  cksum <<<$1 | awk '{print $1}'
}

_build() {
  local input=$1
  local title="${input##*/}"
  # local cataloggroup=${MARKDOWN_GROUP:-classification}
  title="${title%%.*}"
  title="${title^}"

  MARKDOWN_TITLE=$title $DIR/catalog.sh $input --simple --markdown $MARKDOWN_GROUP | cat -s >./${title}.md
}

while [ $# -gt 0 ]; do
  case $1 in
  -g | --group) MARKDOWN_GROUP="$2" && shift ;;
  -t | --title) MARKDOWN_TITLE="$2" && shift ;;
  -e | --exclude) MARKDOWN_EXCLUDE="$2" && shift ;;
  -a | --all) MARKDOWN_EXCLUDE="" ;;
  -Y | --exclude-year) _exclude+=("[2][0-2][0-3][0-9]" "[CF]Y[0-2][0-9]") ;;
  *\.json) MARKDOWN_INPUT+=("$1") ;;
  esac
  shift || break
done

MARKDOWN_EXCLUDE="$(join_by '|' "${_exclude[@]}")"

for i in "${MARKDOWN_INPUT[@]}"; do
  if [[ -n $i ]]; then
    _build $i &
  fi
done

wait
