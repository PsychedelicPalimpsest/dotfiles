#!/bin/sh

echo "source ~/.aliases || true ; " $(dmenu_path | dmenu "$@")  | ${SHELL:-"/bin/bash"} &