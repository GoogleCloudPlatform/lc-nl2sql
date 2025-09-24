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


echo "Use Kaggle w/ gemini-1.5-pro"
input_file_sk100="lc_nl2sql/data/kaggle_dev_example_synthetic_examples_100.json"
if [[ ! -f "$input_file_sk100" ]]; then
  python lc_nl2sql/data_process/sql_data_process.py \
  --input_data_path lc_nl2sql/data/kaggle/dev.json \
  --input_table_path lc_nl2sql/data/kaggle/KaggleDBQA_tables.json \
  --output_file_path "$input_file_sk100" \
  --source_type "kaggle" \
  --db_folder_path lc_nl2sql/data/kaggle/databases \
  --db_tbl_col_vals_file db_tbl_col_vals_kaggle.pickle \
  --num_col_values 10 \
  --use_column_filtering 1\
  --filtered_schema_file lc_nl2sql/data/kaggle/col_selection_schema.csv \
  --synthetic_examples 1 \
  --num_examples 200
  
fi

python lc_nl2sql/predict/predict.py \
  --predicted_input_filename "$input_file_sk100" \
  --db_tbl_col_vals_file db_tbl_col_vals_kaggle.pickle \
  --num_beams 10 \
  --temperature 0.5 \
  --use_self_correction 1 \
  --use_disambiguation 1 \
  --db_folder_path lc_nl2sql/data/kaggle/databases \
  --predicted_out_filename "lc_nl2sql/output/pred/kaggle_benchmark.sql"

python lc_nl2sql/predict/measure_latency.py \
  --predicted_input_filename "$input_file_sk100" \
  --use_self_correction 0 \
  --predicted_out_filename "lc_nl2sql/output/pred/latency/kaggle_measure_latency"
 

echo "Use Kaggle w/ gemini-1.5-flash"
input_file_sk100="lc_nl2sql/data/kaggle_dev_example_synthetic_examples_100_flash.json"
if [[ ! -f "$input_file_sk100" ]]; then
  python lc_nl2sql/data_process/sql_data_process.py \
  --input_data_path lc_nl2sql/data/kaggle/dev.json \
  --input_table_path lc_nl2sql/data/kaggle/KaggleDBQA_tables.json \
  --output_file_path "$input_file_sk100" \
  --source_type "kaggle" \
  --db_folder_path lc_nl2sql/data/kaggle/databases \
  --db_tbl_col_vals_file db_tbl_col_vals_kaggle.pickle \
  --num_col_values 10 \
  --synthetic_examples 1 \
  --use_column_filtering 1\
  --filtered_schema_file lc_nl2sql/data/kaggle/col_selection_schema.csv \
  --use_flash 1 \
  --num_examples 200
fi

python lc_nl2sql/predict/predict.py \
  --predicted_input_filename "$input_file_sk100" \
  --db_tbl_col_vals_file db_tbl_col_vals_kaggle.pickle \
  --num_beams 10 \
  --temperature 0.5 \
  --use_self_correction 1 \
  --use_disambiguation 1 \
  --use_flash 1 \
  --db_folder_path lc_nl2sql/data/kaggle/databases \
  --predicted_out_filename "lc_nl2sql/output/pred/kaggle_benchmark_flash.sql"

python lc_nl2sql/predict/measure_latency.py \
  --predicted_input_filename "$input_file_sk100" \
  --use_self_correction 0 \
  --use_flash 1 \
  --predicted_out_filename "lc_nl2sql/output/pred/latency/kaggle_measure_latency_flash"
