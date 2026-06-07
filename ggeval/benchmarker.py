from .evaluator import Evaluator
from .model_runner import ModelRunner
from datetime import datetime
import mlflow


class Benchmarker:
    def __init__(
        self,
        models,
        prompt_data,
        experiment_name="benchmark",
        device_map="cpu",
    ):
        self.models = models
        self.prompt_data = prompt_data
        self.experiment_name = experiment_name
        self.device_map = device_map

    def benchmark(self):
        mlflow.set_experiment(self.experiment_name)
        n_evals = len(self.models) * len(self.prompt_data)
        evals = 1

        run_name = datetime.now().strftime("benchmark_%Y_%m_%d_%H_%M_%S")
        with mlflow.start_run(run_name=run_name) as parent:
            for short_name in self.models:
                print(f"Loading {short_name}...")
                model = ModelRunner(self.models[short_name], self.device_map)

                with mlflow.start_run(run_name=short_name, nested=True):
                    mlflow.log_param("model_name", short_name)
                    correct = 0
                    total_latency = 0

                    for prompt in self.prompt_data:
                        print(
                            f"{evals}/{n_evals}: "
                            f"Evaluating {short_name} on {prompt['id']}."
                        )
                        evals += 1
                        response = model.generate(prompt["prompt"])
                        submission = response["response_parsed"]
                        latency = response["latency"]
                        evaluator = Evaluator(
                            prompt_id=prompt["id"],
                            answer=prompt["answer"],
                            submission=submission,
                            model_name=short_name,
                        )
                        evaluator.export_eval_script()

                        result = evaluator.run_eval_script()
                        correct += int(result)
                        total_latency += latency

                        mlflow.log_metrics(
                            {
                                f"{prompt['id']}/correct": int(result),
                                f"{prompt['id']}/latency": latency,
                            }
                        )
                        print(f"Result: {result}, Latency: {latency}")

                    mlflow.log_metrics(
                        {
                            "accuracy": correct / len(self.prompt_data),
                            "mean_latency": total_latency
                            / len(self.prompt_data),
                        }
                    )
