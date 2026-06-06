# ggeval: A ggplot2 evaluation pipeline

This repo contains an LLM evaluation/benchmarking pipeline for plot generation with the R package ggplot2.
It is set up to assess a

## Evaluation

Evaluation is based on prompts/answer pairs stored in `ggeval/prompt_data.json`.

An example prompt/answer pair looks like:

```
"prompt": "The palmerpenguins dataframe can be made available in R by calling `library(palmerpenguins)`. The dataframe is named `penguins`. It has the following factor columns: species, island, sex. It has the following numeric columns: bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g, year. The palmerpenguins and ggplot2 libraries have been loaded for you. Construct a boxplot plot with species on the x-axis and bill_length_mm on the y-axis. Do not store the plot in a variable. Respond with code only; no explanation. Do not re-iterate your objective or state anything about your reasoning process."
```

```
"answer": "ggplot(penguins, aes(x = species, y = bill_length_mm)) + geom_boxplot()"
```

There are 39 prompt/answer pairs in `ggeval/prompt_data.json` that gradually increase in complexity.
I wrote the first two and have manually verified the remaining 37 written by Claude Sonnet 4.6.

## Structure

The pipeline relies on three classes:

1. `ModelRunner`
    - loads models
    - manages prompting and response parsing
2. `Evaluator`
    - runs and compares the reference answer and LLM answer for each prompt in a Podman container
    - exports figures


## Model selection

Models were selected based on information from the LLM Stats Open LLM Leaderboard: https://llm-stats.com/leaderboards/open-llm-leaderboard collected on May 26th, 2026.

Only open-source models capable of running on the smallest LLM stats hardware tier (<= 4B, "Phone SoC") were considered.
For each provider, only the model meeting these criteria with the highest LLM Stats Reasoning Index (https://llm-stats.com/leaderboards/best-ai-for-reasoning) was included.

- Qwen3.5-4B
- Ministral 3B Reasoning 2512
- Phi 4 Mini Reasoning
- DeepSeek R1 Distill Qwen 1.5B
- Gemma 3 4B
- Llama 3.2 3B Instruct

I also included IBM's Granite-3.3-2B-Instruct, which is another small model appearing in many of my searches but seems to have not yet been added to the LLM Stats Open LLM Leaderboard.
