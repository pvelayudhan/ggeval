from ggeval.model_runner import ModelRunner
import json

models = {
    "gemma": "google/gemma-3-4b-it",
    "qwen": "Qwen/Qwen2.5-1.5B-Instruct",
    "ministral": "mistralai/Ministral-3-3B-Reasoning-2512",
    "r1distill": "deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B",
    "phi4mini": "microsoft/Phi-4-mini-reasoning",
    "granite": "ibm-granite/granite-3.3-2b-instruct",
    "llama": "meta-llama/Llama-3.2-3B-Instruct"
}

model_name = "qwen"

model = ModelRunner(models[model_name])

with open('ggeval/prompts.json') as f:
    d = json.load(f)

prompt     = d[0]['prompt']
prompt_id  = d[0]['id']
answer     = d[0]['answer']

submission = model.generate(prompt)['response-parsed']

from ggeval.evaluator import Evaluator
evaluator = Evaluator(prompt_id, answer, submission, model_name)
evaluator.export_eval_script()
evaluator.run_eval_script()
