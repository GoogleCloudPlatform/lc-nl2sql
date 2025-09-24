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


python lc_nl2sql/process_and_predict.py \
        --input_data_path lc_nl2sql/data/bird/dev/dev.json \
        --input_table_path lc_nl2sql/data/bird/dev/dev_tables.json \
        --db_folder_path lc_nl2sql/data/bird/dev/dev_databases \
        --filtered_schema_file lc_nl2sql/data/bird/col_selection_schema.csv \
        --db_tbl_col_vals_file lc_nl2sql/data/bird/db_tbl_col_vals.pickle \
        --temperature 1.8 \
        --use_column_filtering 1 \
        --num_examples 100 \
        --synthetic_examples 1 \
        --vertex_ai_project_id 400355794761 \
        --num_candidates 9

directory="output.csv"
multi_sql_mode="${3:-upper}"
n_cands=(1 3 5 7 9) 
for n in "${n_cands[@]}"; do
  python lc_nl2sql/eval/evaluation_bird.py \
        --sql_candidates_path "$directory" \
        --ground_truth_path lc_nl2sql/data/bird/dev/dev.sql \
        --db_root_path lc_nl2sql/data/bird/dev/dev_databases/ \
        --num_cpus 24 \
        --etype exec \
        --gt_tied_json_path lc_nl2sql/data/bird/dev/dev_tied_append.json \
        --diff_json_path lc_nl2sql/data/bird/dev/dev.json \
        --multi_sql_mode "upper" \
        --n_cands "$n"
done