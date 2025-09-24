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


# long document selection experiment
n_documents=(1 2 3)
for k in "${n_documents[@]}"; do
  echo "Running with $k long document chunks"
  python lc_nl2sql/data_process/sql_data_process.py \
  --input_data_path lc_nl2sql/data/kaggle/dev.json \
  --input_table_path lc_nl2sql/data/kaggle/KaggleDBQA_tables.json \
  --source_type "kaggle" \
  --db_folder_path lc_nl2sql/data/kaggle/databases \
  --db_tbl_col_vals_file db_tbl_col_vals_kaggle.pickle \
  --document_pool_type long \
  --document_selection_file lc_nl2sql/data/kaggle/dev_doc.json \
  --num_documents "$k"

  python lc_nl2sql/predict/predict.py \
  --predicted_input_filename lc_nl2sql/data/example_text2sql_dev.json \
  --num_beams 1 \
  --temperature 0.5 \
  --db_folder_path lc_nl2sql/data/kaggle/databases \
  --db_tbl_col_vals_file db_tbl_col_vals_kaggle.pickle \
  --predicted_out_filename "lc_nl2sql/output/pred/kaggle_document_selection_long_$k"

  python lc_nl2sql/predict/count_token.py \
  --predicted_input_filename lc_nl2sql/data/example_text2sql_dev.json \
  --predicted_out_filename "lc_nl2sql/output/pred/token_count/kaggle_document_selection_long_$k" 

done

# short document selection experiment
n_documents=(1 5 10 15)
for k in "${n_documents[@]}"; do
  echo "Running with $k short document chunks"
  python lc_nl2sql/data_process/sql_data_process.py \
  --input_data_path lc_nl2sql/data/kaggle/dev.json \
  --input_table_path lc_nl2sql/data/kaggle/KaggleDBQA_tables.json \
  --source_type "kaggle" \
  --db_folder_path lc_nl2sql/data/kaggle/databases \
  --db_tbl_col_vals_file db_tbl_col_vals_kaggle.pickle \
  --document_pool_type short \
  --document_selection_file lc_nl2sql/data/kaggle/dev_doc.json \
  --num_documents "$k"

  python lc_nl2sql/predict/predict.py \
  --predicted_input_filename lc_nl2sql/data/example_text2sql_dev.json \
  --num_beams 1 \
  --temperature 0.5 \
  --db_folder_path lc_nl2sql/data/kaggle/databases \
  --db_tbl_col_vals_file db_tbl_col_vals_kaggle.pickle \
  --predicted_out_filename "lc_nl2sql/output/pred/kaggle_document_selection_short_$k"

  python lc_nl2sql/predict/count_token.py \
  --predicted_input_filename lc_nl2sql/data/example_text2sql_dev.json \
  --predicted_out_filename "lc_nl2sql/output/pred/token_count/kaggle_document_selection_short_$k" 

done