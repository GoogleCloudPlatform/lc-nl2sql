#!/bin/bash
# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


prefix="$1"
directory="$2"
multi_sql_mode="${3:-upper}"
n_cands="${4:--1}"          

if [ -z "$prefix" ] || [ -z "$directory" ]; then
  echo "Error: Please provide a prefix and directory path as arguments."
  exit 1
fi

if [[ "$prefix" == "cand" ]]; then
  python lc_nl2sql/eval/evaluation_bird.py \
        --sql_candidates_path "$directory" \
        --ground_truth_path lc_nl2sql/data/bird/dev/dev.sql \
        --db_root_path lc_nl2sql/data/bird/dev/dev_databases/ \
        --num_cpus 24 \
        --etype exec \
        --gt_tied_json_path lc_nl2sql/data/bird/dev/dev_tied_append.json \
        --diff_json_path lc_nl2sql/data/bird/dev/dev.json \
        --multi_sql_mode "$multi_sql_mode" \
        --n_cands "$n_cands"
else
  for pred_sql in "$directory"/"$prefix"*; do
    if [ -f "$pred_sql" ]; then
      echo "Processing file: $pred_sql"

      python lc_nl2sql/eval/evaluation_bird.py \
        --predicted_sql_path "$pred_sql" \
        --ground_truth_path lc_nl2sql/data/bird/dev/dev.sql \
        --db_root_path lc_nl2sql/data/bird/dev/dev_databases/ \
        --num_cpus 24 \
        --etype exec \
        --gt_tied_json_path lc_nl2sql/data/bird/dev/dev_tied_append.json \
        --diff_json_path lc_nl2sql/data/bird/dev/dev.json

    fi
done
fi

