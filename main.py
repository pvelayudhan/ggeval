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

#script_name = prompt_id + "_" + model_name + "_eval_run.R"

#r_script = f"""
#    library(ggplot2)
#    library(palmerpenguins)
#    built_answer <- tryCatch(
#        {{
#            set.seed(42)
#            {answer}
#            suppressWarnings(ggsave(width = 3, height = 3, "figures/{prompt_id}_answer.png"))
#            suppressWarnings(ggplot_build(last_plot()))
#        }},
#        error = function(e) {{
#            FALSE
#        }}
#    )
#    built_submission <- tryCatch(
#        {{
#            set.seed(42)
#            {submission}
#            suppressWarnings(ggsave(width = 3, height = 3, "figures/{prompt_id}_{model_name}_submission.png"))
#            suppressWarnings(ggplot_build(last_plot()))
#        }},
#        error = function(e) {{
#            FALSE
#        }}
#    )
#    print(isTRUE(all.equal(built_answer, built_submission)))
#"""

#with open((f"scripts/{script_name}"), "w") as f:
#    f.write(r_script)




"""
pipeline:

    1. Load model
    2. Give model the prompt
    3. Export prompt, response, and answer into evaluation script in R
    4. ...

"""
