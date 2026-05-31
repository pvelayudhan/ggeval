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

# works
#model = ModelRunner(models["gemma"])
#model = ModelRunner(models["ministral"])
#model = ModelRunner(models["r1distill"])
#model = ModelRunner(models["phi4mini"])
#model = ModelRunner(models["granite"])
#model = ModelRunner(models["llama"])
model = ModelRunner(models["qwen"])


with open('ggeval/prompts.json') as f:
    d = json.load(f)

print(d[0]['id'])

prompt = d[0]['prompt']
answer = d[0]['answer']

submission = model.generate(prompt)

submission = submission['response-parsed']

answer

r_script = f"""
library(ggplot2)
library(palmerpenguins)
set.seed(42)
{answer}
built_answer <- ggplot_build(last_plot())
set.seed(42)
{submission}
built_submission <- ggplot_build(last_plot())
source("evaluator.R")
evaluate(built_answer, built_submission)
"""

with open("eval_run.R", "w") as f:
    f.write(r_script)



"""
pipeline:

    1. Load model
    2. Give model the prompt
    3. Export prompt, response, and answer into evaluation script in R
    4. ...

"""

print(result["response-raw"])
print('---')
print(result["response-parsed"])
print('---')
print(result["latency"])

def save_r_script(self, response, path):
    with open(path, "w") as f:
        f.write(response)

#model = ModelWrapper("google/gemma-3-4b-it")
#evaluator = Evaluator()
#logger = ResultsLogger()
#benchmark = Benchmark(model, evaluator, logger)
#benchmark.run()
