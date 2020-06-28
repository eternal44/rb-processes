#!/bin/bash
# NOTE: script receives target benchmark file size as megabytes. All file size
# references in this script are in kilobytes

USER_INPUT=$1
TARGET_SIZE=$(($USER_INPUT * 1000))

SEED_FILE=./input-files/large-sample-data.txt
SEED_FILE_SIZE=180
BENCHMARK_FILE=./input-files/benchmark-input.txt
ITERATIONS=$(expr $TARGET_SIZE / $SEED_FILE_SIZE)

cp $SEED_FILE $BENCHMARK_FILE

for (( i = 0; i <= $ITERATIONS; i++ ))
do
  cat $SEED_FILE >> $BENCHMARK_FILE
done
