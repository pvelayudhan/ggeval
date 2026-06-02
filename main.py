from ggeval.benchmarker import Benchmarker
import json

with open('ggeval/prompt_data.json') as f:
    prompt_data = json.load(f)

#models = {
#    "gemma": "google/gemma-3-4b-it",
#    "qwen": "Qwen/Qwen2.5-1.5B-Instruct",
#    "ministral": "mistralai/Ministral-3-3B-Reasoning-2512",
#    "r1distill": "deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B",
#    "phi4mini": "microsoft/Phi-4-mini-reasoning",
#    "granite": "ibm-granite/granite-3.3-2b-instruct",
#    "llama": "meta-llama/Llama-3.2-3B-Instruct"
#}

models = {
    "qwen": "Qwen/Qwen2.5-1.5B-Instruct"
}

benchmarker = Benchmarker(models, prompt_data)
benchmarker.benchmark()
