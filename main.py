from models.model_wrapper import ModelWrapper

# works
#model = ModelWrapper("google/gemma-3-4b-it")
#model = ModelWrapper("Qwen/Qwen2.5-1.5B-Instruct")
#model = ModelWrapper("mistralai/Ministral-3-3B-Reasoning-2512")
#model = ModelWrapper("deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B")
#model = ModelWrapper("microsoft/Phi-4-mini-reasoning")
#model = ModelWrapper("ibm-granite/granite-3.3-2b-instruct")
#model = ModelWrapper("meta-llama/Llama-3.2-3B-Instruct")

result = model.generate(
"""
The palmerpenguins dataframe can be made available in R by calling `library(palmerpenguins)`.
The dataframe is named `penguins`.
It has the following factor columns: species, island, sex.
It has the following numeric columns: bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g, year.
Using the ggplot2 library, construct a boxplot plot with species on the x-axis and bill_length_mm on the y-axis.
Respond with code only; no explanation.
Do not re-iterate your objective or state anything about your reasoning process.
"""
)

print(result["response"])
print(result["latency"])
