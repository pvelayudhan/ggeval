# ggeval: A ggplot2 evaluation pipeline

This README is 100% human-written.

## Overview

This repo contains an LLM evaluation/benchmarking pipeline for plot generation with the R package ggplot2.
No GPU is necessary.
It is currently set up to evaluate 7 open-source and 2 closed-source models.

The evaluation pipeline will:

- Provide a prompt to generate ggplot2 code from the ggeval dataset [(available on huggingface)](https://huggingface.co/datasets/pvelayudhan/ggeval)
- Export generated R code written by the evaluated model to `scripts/`
- Safely execute that R code in a Podman container
- Evaluate an exact match score of the generated plot's structure against the prompt's associated reference answer
- Export the reference answer plot and (if possible) the LLM-generated plot to `figures/`
- Log per-prompt accuracy, overall accuracy across all prompts, and average latency for response generation across all prompts with MLflow

## Requirements

Apart from the things in requirements.txt, this pipeline uses [Podman](https://podman.io/).

## Evaluation

Evaluation is based on prompts/answer pairs stored in `data/prompt_data.json`.

An example prompt/answer pair looks like:

>"prompt": "The palmerpenguins dataframe can be made available in R by calling `library(palmerpenguins)`. The dataframe is named `penguins`. It has the following factor columns: species, island, sex. It has the following numeric columns: bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g, year. The palmerpenguins and ggplot2 libraries have been loaded for you. Construct a boxplot plot with species on the x-axis and bill_length_mm on the y-axis. Do not store the plot in a variable. Respond with code only; no explanation. Do not re-iterate your objective or state anything about your reasoning process."

>"answer": "ggplot(penguins, aes(x = species, y = bill_length_mm)) + geom_boxplot()"

There are 39 prompt/answer pairs in `ggeval/prompt_data.json` that gradually increase in complexity.
I wrote the first two and have manually verified the remaining 37 written by Claude Sonnet 4.6.

The scoring boils down to the R code:

```R
isTRUE(all.equal(llm_plot, reference_plot))
```

## Structure

The pipeline is structured over three classes:

1. `ModelRunner`
    - Loads models
    - Manages prompting and response parsing
2. `Evaluator`
    - Runs and compares the reference answer and LLM answer for each prompt in a Podman container
    - Exports reference and LLM generated R code and figures to host
3. `Benchmarker`
    - Manages `ModelRunner` and `Evaluator` loops given prompt/answer data and a set of model names
    - Uses MLflow to Log response generation latency for open models and per-task accuracy and overall accuracy for all models


## Model selection

Models were initially selected based on information from the LLM Stats Open LLM Leaderboard: https://llm-stats.com/leaderboards/open-llm-leaderboard collected on May 26th, 2026.

Open-source models capable of running on the website's smallest LLM stats hardware tier (<= 4B, "Phone SoC") were considered.
For each provider, only the model meeting these criteria with the highest LLM Stats Reasoning Index (https://llm-stats.com/leaderboards/best-ai-for-reasoning) was included.
Instruct versions of models were used when possible.

- Gemma 3 4B Instruct
- IBM Granite 3.3 2B Instruct \*
- Llama 3.2 3B Instruct
- Ministral 3B Reasoning 2512\*\*
- Phi 4 Mini Instruct
- Qwen3.5 4B
- Qwen2.5 1.5B Instruct\*\*\*

I also threw in a couple of closed models accessible by API to serve as sanity-checking gold standard models.
If they did poorly, it was a good sign that something was wrong with the evaluation process rather than the models.
Of all the closed model options, these were selected due to their providers offering a free token quota.

- Command A+ (05-2026)
- Gemini 3.5 Flash \*\*\*\*


\*: Although IBM Granite 3.3 did not appear in the Open LLM Leaderboard, it came up a lot in my googling around of small language models.

\*\*: I included the reasoning version of Ministral because I couldn't get the Instruct version to run on my laptop. This ended up being due to some fancy "FP8 dequantization" bug in `transformers-5.9.0`; upgrading to `transformers-5.10.2` enabled the instruct model to run properly (but I am not presenting its evaluation here).

\*\*\*: Qwen2.5 1.5B Instruct was just there as a lightweight placeholder while developing the scripts.
I forgot to remove it from the list of models during the evaluation.
No need to throw away the extra data, though!

\*\*\*\*: I ran out of free Gemini tokens before I could complete the evaluation pipeline. 


## Results

![mlflow screenshot of results](https://raw.githubusercontent.com/pvelayudhan/ggeval/refs/heads/main/results.png?token=GHSAT0AAAAAADSD2GOKJM4WUP3AI5GKARYS2RGAGLA)

I am aware of the irony of presenting my results with an MLflow screenshot.

Good job, **Phi-4 Mini**, for being tied for 1st among the open models with Qwen3.5 but for being quicker about it.
Honourable mentions: Command A+ 05-2026, for not getting shown up by a bunch of <= 4B models, and Qwen2.5 1.5B, for doing things the "Max Power" way. 

I won't go through the process of exploring every single mistake.
All the models did well but none were perfect, which I consider decent evidence of the evaluation pipeline's success.
I will mention that the hardest prompt was "flipper-length_body-mass_scatter_stat_manual_centroid":

> "prompt": "The palmerpenguins dataframe can be made available in R by calling `library(palmerpenguins)`. The dataframe is named `penguins`. It has the following factor columns: species, island, sex. It has the following numeric columns: bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g, year. The palmerpenguins and ggplot2 libraries have been loaded for you. Construct a scatter plot with flipper_length_mm on the x-axis and body_mass_g on the y-axis, with points coloured by species and alpha = 0.4. Add a stat_manual() layer that plots the per-species centroid as a large filled point (size = 6, shape = 21) using fun = function(data) data.frame(x = mean(data$x, na.rm = TRUE), y = mean(data$y, na.rm = TRUE)) and geom = \"point\", also coloured by species. Do not store the plot in a variable. Respond with code only; no explanation. Do not re-iterate your objective or state anything about your reasoning process.",
    
The correct answer was:

```R
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, colour = species)) +
    geom_point(alpha = 0.4) +
    stat_manual(
        geom = "point",
        fun = function(data) data.frame(
            x = mean(data$x, na.rm = TRUE),
            y = mean(data$y, na.rm = TRUE)
        ),
        size = 6,
        shape = 21
    )
```

The two Qwen models were the only ones to succeed!
Command A+'s answer:

```R 
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, colour = species)) +
geom_point(alpha = 0.4) +
stat_manual(
    fun = function(data) data.frame(
        x = mean(data$x, na.rm = TRUE),
        y = mean(data$y, na.rm = TRUE),
        species = unique(data$species)[1]
    ),
    geom = "point",
    aes(size = 6, shape = 21, colour = species, fill = species)
)
```

Close!

## Limitations

- *Evaluation order effects on latency*: All prompts were processed for each model before moving on to the next model, meaning time effects were not controlled for during the evaluation. It is possible some model had unfairly high or low latencies due to how warmed up / cooked my laptop was when it was that model's turn for evaluation. Shuffling model-prompt evaluation orders could remedy this.
- *Temperature fixed at 0*: maybe results would be different by giving models their provided-recommended default temperatures
- *Mixing model types and thinking handling*: To prevent thinking output from interfering with code execution, thinking is suppressed by instructions within the prompts, with `enable_thinking=False` in the `tokenizer.apply_chat_template()` call, and with output post-processing. The mixture of approaches and types of models included can make the final comparisons unfair. Some models may perform better when thinking is not suppressed in the `apply_chat_template()` call. Some models may burn too many tokens on their thinking blocks to achieve the final task in within the specified token limit (512 in this project). 
- *Error handling*: Timeout / quota-exceeded errors for LLMs accessed by API are not handled well. The primary purpose of the pipeline is to evaluate small local language models that can run on light hardware, so handling things like quota errors was not a top priority.
- *Hard-coding during model loading*: The `ModelRunner` class responsible for loading models by name looks a little gross in terms of the if-statements needed to get everything working.
- *Evaluation approach*: Models receive a point if they exactly replicate the reference answer and no points if they do not. Scoring functioning code missing one or two elements differently from complete error-producing gibberish would be an improvement.
- *Cause of failure tracking*: In a related point to the above, I do not clearly track the cause of a failed task. Examples include running out of tokens, generating malformed code, generating functioning code mixed with invalid text that did not get cleared by post-processing, generating functioning code that did not correctly answer the prompt, and, most fatal of all, generating functioning code that does technically correctly address the prompt but for some other reason did not pass the `all.equal()` comparison test.
- *ggplot2 coverage*: There are many areas of ggplot2 that are not tested in the associated prompt/answer dataset
