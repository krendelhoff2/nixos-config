#!/usr/bin/env bash

if [[ -n "$1" ]]; then
    setxkbmap "$1"
else
    layout=$(setxkbmap -query | awk 'FNR == 3 {print $2}')
    case $layout in
    us)
        setxkbmap ru
        ;;
    *)
        setxkbmap us -variant colemak_dh
        ;;
    esac
fi
