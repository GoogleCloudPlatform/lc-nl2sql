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

if [ -z "$prefix" ] || [ -z "$directory" ]; then
  echo "Error: Please provide a prefix and directory path as arguments."
  exit 1
fi

for pred_sql in "$directory"/"$prefix"*; do
  if [ -f "$pred_sql" ]; then
    echo "Processing file: $pred_sql"

    python lc_nl2sql/eval/evaluation.py \
      --input "$pred_sql" \
      --gold lc_nl2sql/data/spider/test_data/dev_gold.sql \
      --db lc_nl2sql/data/spider/test_database/ \
      --table lc_nl2sql/data/spider/test_data/tables.json \
      --etype exec
  fi
done

