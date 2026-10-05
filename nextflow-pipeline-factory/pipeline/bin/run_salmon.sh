#!/usr/bin/env bash
# Plain bash script. Nextflow puts bin/ on the PATH of every task automatically.
set -euo pipefail
sample_id=$1; index=$2; r1=$3; r2=$4; threads=$5

salmon quant \
  -i "$index" -l A \
  -1 "$r1" -2 "$r2" \
  -p "$threads" --validateMappings \
  -o "$sample_id"
