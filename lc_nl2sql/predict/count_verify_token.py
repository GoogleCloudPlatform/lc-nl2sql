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

import os
import sys
import numpy as np
import logging
import math

ROOT_PATH = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.append(ROOT_PATH)

from lc_nl2sql.configs.config import VERIFY_ANSWER

from typing import List, Dict
from lc_nl2sql.llm_base.api_model import GeminiModel
from lc_nl2sql.predict.predict import prepare_dataset, extract_output

def count_token(model: GeminiModel, predict_data: List[Dict], output_sqls: List[str], sample=True):
    tok_cnts = []
    for i, item in enumerate(predict_data):
        if sample and i % 5 != 0:
            # Counting based on every other five questions
            continue
        schema = item["input"].split('###Table creation statements###'
            )[1].split('***************************')[0]
        question = item["input"].split("###Question###"
                                       )[1].split('***************************')[0]
        sql = output_sqls[i]
        prompt = VERIFY_ANSWER.format(sql=sql, question=question, schema=schema)
        tok_cnts.append(model._count_token(prompt))
    return tok_cnts


def predict(model: GeminiModel, dump_file=True):
    args = model.data_args
    ## predict file can be give by param --predicted_input_filename ,output_file can be gived by param predicted_out_filename
    predict_data = prepare_dataset(args.predicted_input_filename)
    output_sqls = extract_output(args.predicted_input_filename)
    tok_cnts = count_token(model, predict_data, output_sqls)
    avg_tok = np.mean(tok_cnts)
    std_tok = np.std(tok_cnts)

    if dump_file:
        with open(args.predicted_out_filename, "w") as f:
            f.write(str(avg_tok) + ", " + str(std_tok))
    else:
        return avg_tok, std_tok


if __name__ == "__main__":
    model = GeminiModel()
    model._infer_args()
    predict(model)
