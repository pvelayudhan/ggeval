from ggeval.model_runner import ModelRunner

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
model = ModelRunner(models["qwen"])
#model = ModelRunner(models["ministral"])
#model = ModelRunner(models["r1distill"])
#model = ModelRunner(models["phi4mini"])
#model = ModelRunner(models["granite"])
#model = ModelRunner(models["llama"])

result = model.generate(
"""
The palmerpenguins dataframe can be made available in R by calling `library(palmerpenguins)`.
The dataframe is named `penguins`.
It has the following factor columns: species, island, sex.
It has the following numeric columns: bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g, year.
The palmerpenguins and ggplot2 libraries have been loaded for you.
Construct a boxplot plot with species on the x-axis and bill_length_mm on the y-axis.
Respond with code only; no explanation.
Do not re-iterate your objective or state anything about your reasoning process.
"""
)

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
