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


# produce lc_nl2sql/data/bird/similar_examples.json
 python lc_nl2sql/data_process/retrieve_similar_examples.py \ 
 --project-id sysres-disagg-ml \
 --train-only-example-pool-path lc_nl2sql/data/train/train.json \ 
 --queries-path lc_nl2sql/data/bird/dev.json \
 --output-dir lc_nl2sql/data/bird \ 
 --synthetic-example-pool-path lc_nl2sql/data/bird/synthetic_examples.json
