from models.model_wrapper import ModelWrapper


#- Ministral 3B Reasoning 2512
#- Phi 4 Mini Reasoning
#- DeepSeek R1 Distill Qwen 1.5B
#- Llama 3.2 3B Instruct
#model = ModelWrapper("deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B")

model = ModelWrapper("google/gemma-3-4b-it") # doesn't work?
#model = ModelWrapper("Qwen/Qwen2.5-1.5B-Instruct")

result = model.generate(
"""
The palmerpenguins dataframe can be made available in R by calling `library(palmerpenguins)`.
The dataframe is named `penguins`.
It has the following factor columns: species, island, sex.
It has the following numeric columns: bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g, year.
Using the ggplot2 library, construct a boxplot plot with species on the x-axis and bill_length_mm on the y-axis.
"""
)

print(result["response"])
print(result["latency"])
