# ggbench: Evaluating SLMs on ggplot2

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
