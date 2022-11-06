#!/usr/bin/env bash

EWW=`which eww`
CFG="$HOME/.config/eww/arin"

## Open widgets
run_eww() {
${EWW} --config "$CFG" open-many \
  apps \
  weather \
  music \
  system \
  workspaces
}

## Launch or close widgets accordingly
run_eww
