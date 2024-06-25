#!/usr/bin/env bash
ls -1 ./catalog/*.md | jq -Rrs 'split("\n")[]|select(length >0)|"* [\(.|split("/")|last)](\(.))"'
