# ggeval: A ggplot2 evaluation pipeline

## Overview

This repo contains an LLM evaluation/benchmarking pipeline for plot generation with the R package ggplot2.
It is currently set up to support 7 open-source and 2 closed-source model providers.
The evaluation pipeline will:

+ Provide a prompt to generate ggplot2 code from the ggeval dataset (https://huggingface.co/datasets/pvelayudhan/ggeval)
+ Export generated R code written by the evaluated model to `scripts/`
+ Safely execute that R code in a Podman container
+ Evaluate exact match of the generated plot's structure with the prompt's associated reference answer
+ Export the reference answer plot and (if possible) the LLM-generated plot to `figures/`
+ Log per-prompt accuracy, overall accuracy across all prompts, and average latency for response generation across all prompts with MLflow

## Evaluation

Evaluation is based on prompts/answer pairs stored in `data/prompt_data.json`.

An example prompt/answer pair looks like:

>"prompt": "The palmerpenguins dataframe can be made available in R by calling `library(palmerpenguins)`. The dataframe is named `penguins`. It has the following factor columns: species, island, sex. It has the following numeric columns: bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g, year. The palmerpenguins and ggplot2 libraries have been loaded for you. Construct a boxplot plot with species on the x-axis and bill_length_mm on the y-axis. Do not store the plot in a variable. Respond with code only; no explanation. Do not re-iterate your objective or state anything about your reasoning process."

>"answer": "ggplot(penguins, aes(x = species, y = bill_length_mm)) + geom_boxplot()"

There are 39 prompt/answer pairs in `ggeval/prompt_data.json` that gradually increase in complexity.
I wrote the first two and have manually verified the remaining 37 written by Claude Sonnet 4.6.

## Structure

The pipeline relies uses three classes:

1. `ModelRunner`
    - loads models
    - manages prompting and response parsing
2. `Evaluator`
    - runs and compares the reference answer and LLM answer for each prompt in a Podman container
    - exports figures


## Model selection

Models were selected based on information from the LLM Stats Open LLM Leaderboard: https://llm-stats.com/leaderboards/open-llm-leaderboard collected on May 26th, 2026.

Only open-source models capable of running on the website's smallest LLM stats hardware tier (<= 4B, "Phone SoC") were considered.
For each provider, only the model meeting these criteria with the highest LLM Stats Reasoning Index (https://llm-stats.com/leaderboards/best-ai-for-reasoning) was included.

- Qwen3.5-4B
- Ministral 3B Reasoning 2512
- Phi 4 Mini Reasoning
- DeepSeek R1 Distill Qwen 1.5B
- Gemma 3 4B
- Llama 3.2 3B Instruct

    "ministral": "mistralai/Ministral-3-3B-Reasoning-2512",
    "phi4mini": "microsoft/Phi-4-mini-reasoning",
    "r1distill": "deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B",
    "gemma": "google/gemma-3-4b-it",
    "llama": "meta-llama/Llama-3.2-3B-Instruct",
    "granite": "ibm-granite/granite-3.3-2b-instruct",
    "qwen": "Qwen/Qwen2.5-1.5B-Instruct"



    #"command-a-plus": "command-a-plus-05-2026",
    #"gemini": "gemini-3.5-flash",

I also included IBM's Granite-3.3-2B-Instruct, which is another small model appearing in many of my searches but seems to have not yet been added to the LLM Stats Open LLM Leaderboard.


## Some obvious limitations / areas to improve

+ Mixing model types and thinking handling: To prevent thinking output from interfering with code execution, thinking is suppressed by instructions within the prompts, with `enable_thinking=False` in the `tokenizer.apply_chat_template()` call, and with regex-based a post-processing. The mixture of approaches and types of models included can make the final comparisons unfair. Some models may perform better when thinking is not suppressed in the `apply_chat_template()` call. Some models may burn too many tokens on their thinking blocks to achieve the final task in within the specified token limit (512 in this project). 
+ Error handling: Timeout / quota-exceeded errors for LLMs accessed by API are not handled well. The primary purpose of the pipeline is to evaluate small local language models that can run on light hardware, so handling things like quota errors was not a top priority.
+ Hard-coding during model loading: The `ModelRunner` class responsible for loading models by name looks a little gross in terms of the if-statements needed to get everything working.
+ Evaluation approach: Models receive a point if they exactly replicate the reference answer and no points if they do not. It might make more sense to provide partial marks for partially correct answers.
+ ggplot2 coverage: There are many areas of ggplot2 that are not tested in the associated prompt/answer dataset
