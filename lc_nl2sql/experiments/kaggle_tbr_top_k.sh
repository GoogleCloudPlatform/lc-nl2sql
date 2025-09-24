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


# Use all the tables from DB
echo "Running with top_k = all tables from DB"
python lc_nl2sql/data_process/sql_data_process.py \
  --input_data_path lc_nl2sql/data/kaggle/dev.json \
  --input_table_path lc_nl2sql/data/kaggle/KaggleDBQA_tables.json \
  --db_tbl_col_vals_file db_tbl_col_vals_kaggle.pickle \
  --source_type "kaggle" \
  --db_folder_path lc_nl2sql/data/kaggle/databases

python lc_nl2sql/predict/predict.py \
  --predicted_input_filename lc_nl2sql/data/example_text2sql_dev.json \
  --db_tbl_col_vals_file db_tbl_col_vals_kaggle.pickle \
  --num_beams 1 \
  --temperature 0.5 \
  --db_folder_path lc_nl2sql/data/kaggle/databases \
  --predicted_out_filename "lc_nl2sql/output/pred/kaggle_tbr_top_all_tables"

python lc_nl2sql/predict/count_token.py \
  --predicted_input_filename lc_nl2sql/data/example_text2sql_dev.json \
  --predicted_out_filename "lc_nl2sql/output/pred/token_count/kaggle_tbr_top_all_tables"

echo "Running with top_k = all tables from DB"
python lc_nl2sql/data_process/sql_data_process.py \
  --input_data_path lc_nl2sql/data/kaggle/dev.json \
  --input_table_path lc_nl2sql/data/kaggle/KaggleDBQA_tables.json \
  --db_tbl_col_vals_file db_tbl_col_vals_kaggle.pickle \
  --source_type "kaggle" \
  --db_folder_path lc_nl2sql/data/kaggle/databases \
  --extra_top_k 100

python lc_nl2sql/predict/predict.py \
  --predicted_input_filename lc_nl2sql/data/example_text2sql_dev.json \
  --db_tbl_col_vals_file db_tbl_col_vals_kaggle.pickle \
  --num_beams 1 \
  --temperature 0.5 \
  --db_folder_path lc_nl2sql/data/kaggle/databases \
  --predicted_out_filename "lc_nl2sql/output/pred/kaggle_tbr_top_all_dbs"

python lc_nl2sql/predict/count_token.py \
  --predicted_input_filename lc_nl2sql/data/example_text2sql_dev.json \
  --predicted_out_filename "lc_nl2sql/output/pred/token_count/kaggle_tbr_top_all_dbs"

# Use simulated TBR with top_k and draw tables across the DBs.
k_values=(1 2 5) 
for k in "${k_values[@]}"; do
  echo "Running with top_k = $k"
  python lc_nl2sql/data_process/sql_data_process.py \
    --input_data_path lc_nl2sql/data/kaggle/dev.json \
    --input_table_path lc_nl2sql/data/kaggle/KaggleDBQA_tables.json \
    --db_tbl_col_vals_file db_tbl_col_vals_kaggle.pickle \
    --source_type "kaggle" \
    --db_folder_path lc_nl2sql/data/kaggle/databases \
    --tbr_selection_file lc_nl2sql/data/kaggle/tbr_dump.json \
    --extra_top_k "$k"

  python lc_nl2sql/predict/predict.py \
    --predicted_input_filename lc_nl2sql/data/example_text2sql_dev.json \
    --num_beams 1 \
    --db_tbl_col_vals_file db_tbl_col_vals_kaggle.pickle \
    --temperature 0.5 \
    --db_folder_path lc_nl2sql/data/kaggle/databases \
    --predicted_out_filename "lc_nl2sql/output/pred/kaggle_tbr_top_$k" 

  python lc_nl2sql/predict/count_token.py \
    --predicted_input_filename lc_nl2sql/data/example_text2sql_dev.json \
    --predicted_out_filename "lc_nl2sql/output/pred/token_count/kaggle_tbr_top_$k" 

done