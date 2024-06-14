#!/usr/bin/env bash

SCRIPT="$(realpath $0)"
DIR=${SCRIPT%/*}

# CATALOG_FILE=$1
CATALOG_FUNC=get_simple

_flags="-"
_funcs=()

_log() { echo -e "\033[0;${2:-37}m$1\033[0m" 3>&2 2>&1 >&3 3>&-; }

function join_by {
  local IFS="$1"
  shift
  echo "$*"
}

IFS=$'\n'
while [ $# -gt 0 ]; do
  case $1 in
  -j | --json) CATALOG_FILE="$2" && shift ;;
  -G | --group-select) _funcs+=("group_by_count($2;$3)") && shift 2 ;;
  --func) _funcs+=("$2") && shift ;;
  --group) _funcs+=("group_by_count($2)") && shift ;;
  --verbose) _funcs+=("get_verbose") ;;
  --columns) _funcs+=("get_columns") ;;
  --simple) _funcs+=("get_simple") ;;

  # --markdown-line)
  #   _funcs+=("markdown_list(\"$2\")")
  #   _flags+="r"
  #   shift
  #   ;;

  --markdown)
    _funcs+=("markdown_catalog($2)")
    _flags+="r"
    shift
    ;;

  *\.json) CATALOG_FILE=$1 ;;
  esac
  shift || break
done

if [[ $_flags == "-" ]]; then
  _flags=""
fi

CATALOG_FUNC="$(join_by '|' ${_funcs[*]})"

_log "
cat $CATALOG_FILE | 
  jq $_flags -L ${DIR/$PWD/.} 'include \"catalog\"; (.results? // .) | ${CATALOG_FUNC}'
" 33

_log $CATALOG_FILE 36

JQ_EXPR="include \"catalog\"; (.results? // .) | ${CATALOG_FUNC}"
cat $CATALOG_FILE | jq $_flags -L $DIR "$JQ_EXPR"
