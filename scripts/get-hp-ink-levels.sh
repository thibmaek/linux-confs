#!/usr/bin/env bash
set -e

INK_LEVELS=$(hp-info 2>&1 | grep -oP "(?<=agent[1-4]-level\\s{18})(.*\\S)" | tr "\\n" ",")

# These have to maintain order since they match the output of hplip's hp-info binary
COLORS=(
  'black'
  'cyan'
  'magenta'
  'yellow'
)

if [ -n "${INK_LEVELS}" ]; then
  IFS=',' read -r -a ink_levels_array <<< "$INK_LEVELS"

  for index in "${!ink_levels_array[@]}"
  do
    if [ -n "${ink_levels_array[index]}" ]; then
      echo "${COLORS[index]} ${ink_levels_array[index]}%"
    fi
  done
fi
