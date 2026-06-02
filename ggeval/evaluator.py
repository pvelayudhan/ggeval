import subprocess


class Evaluator:
    def __init__(self, prompt_id, answer, submission, model_name):
        self.prompt_id = prompt_id
        self.answer = answer
        self.submission = submission
        self.model_name = model_name
        self.answer_img = f"figures/{self.prompt_id}_{answer}.png"
        self.submission_img = (
            f"figures/{self.prompt_id}_{self.model_name}_{submission}.png"
        )
        self.script_name = (
            f"scripts/{self.prompt_id}_{self.model_name}_{eval_run}.R"
        )

    def export_eval_script(self):
        r_script = f"""
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {{
                    set.seed(42)
                    {self.answer}
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "{answer_img}"
                        )
                    )
                    suppressWarnings(ggplot_build(last_plot()))
                }},
                error = function(e) {{
                    FALSE
                }}
            )
            built_submission <- tryCatch(
                {{
                    set.seed(42)
                    {self.submission}
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "{submission_img}"
                        )
                    )
                    suppressWarnings(ggplot_build(last_plot()))
                }},
                error = function(e) {{
                    FALSE
                }}
            )
            print(isTRUE(all.equal(built_answer, built_submission)))
        """

        with open(self.script_name, "w") as f:
            f.write(r_script)

    def run_eval_script(self):
        result = subprocess.run(
            [
                "podman", "run",
                "--rm", # remove container upon exit
                "--network", "none", # don't enable network connectivity
                "--memory", "512m",
                "--cpus", "1",
                "--read-only",
                "--tmpfs", "/tmp",
                "--volume", f"{tmpdir}:/sandbox:ro",
                "--volume", f"{evaluator_path}:/sandbox/evaluator.R:ro",
                "r-eval", # image name
                "Rscript", self.script_name # command
            ],
            capture_output=True,
            text=True,
            timeout=30
        )
