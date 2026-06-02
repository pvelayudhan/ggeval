from .model_runner import ModelRunner
from .evaluator import Evaluator

class Benchmarker:
    def __init__(self, models, prompt_data):
            self.models = models
            self.prompt_data = prompt_data

    def benchmark(self):
        n_evals = len(self.models) * len(self.prompt_data)
        evals = 1
        for model_name in self.models:
            print(f"Loading {model_name}...")
            model = ModelRunner(self.models[model_name])
            for prompt in self.prompt_data:
                print(f"{evals}/{n_evals}: Evaluating {model_name} on {prompt['id']}.")
                evals += 1
                prompt_text = prompt['prompt']
                submission = model.generate(prompt_text)['response-parsed']
                latency = model.generate(prompt_text)['latency']
                evaluator = Evaluator(
                    prompt_id=prompt['id'],
                    answer=prompt['answer'],
                    submission=submission,
                    model_name=model_name
                )
                evaluator.export_eval_script()
                result = evaluator.run_eval_script()
                print(f"Result: {result}, Latency: {latency}")
