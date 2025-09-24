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


k_values=(1 5 10 12) 
for k in "${k_values[@]}"; do
  echo "Running with $k candidates"
  python lc_nl2sql/data_process/sql_data_process.py \
    --input_data_path lc_nl2sql/data/bird/dev/dev.json \
    --input_table_path lc_nl2sql/data/bird/dev/dev_tables.json \
    --db_folder_path lc_nl2sql/data/bird/dev/dev_databases 

  python lc_nl2sql/predict/predict.py \
    --predicted_input_filename lc_nl2sql/data/example_text2sql_dev.json \
    --num_beams "$k" \
    --temperature 0.5 \
    --db_folder_path lc_nl2sql/data/bird/dev/dev_databases \
    --predicted_out_filename "lc_nl2sql/output/pred/bird_multi_choice_$k" 

done