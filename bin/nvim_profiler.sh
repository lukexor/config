#!/usr/bin/env bash

iterations=10

# -----------------------------------------------------------------------------
# Create array of results

declare -a results

for _ in $(seq 1 $iterations);
do
  nvim --startuptime nvim.log files/.config/nvim/init.lua -c 'q'
  latest=$(awk '/./{line=$0} END{print line}' nvim.log | awk '{ print $1}')
  results+=( "$latest" )
done

# -----------------------------------------------------------------------------
# Calculate average

total=0
for delta in "${results[@]}"
do
  total=$(echo $total + "$delta" | bc -l)
done

average=$(echo "$total" / $iterations | bc -l)
echo "$average"
