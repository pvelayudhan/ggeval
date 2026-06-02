import subprocess
import os
import tempfile


class Evaluator:
    def __init__(self, prompt_id, answer, submission, model_name):
        self.prompt_id = prompt_id
        self.answer = answer
        self.submission = submission
        self.model_name = model_name
        self.answer_img = f"/sandbox/figures/{self.prompt_id}_answer.png"
        self.submission_img = (
            f"figures/{self.prompt_id}_{self.model_name}_submission.png"
        )
        self.script_name = (
            f"scripts/{self.prompt_id}_{self.model_name}_eval_run.R"
        )

    def export_eval_script(self):
        r_script = f"""
            print(getwd())
            print(file.access("/sandbox/figures", 2))
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {{
                    set.seed(42)

{self.answer}

                    #suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "{self.answer_img}"
                        )
                    #)
                    #suppressWarnings(
                        ggplot_build(last_plot())
                    #)
                }},
                error = function(e) {{
                    FALSE
                }}
            )
            built_submission <- tryCatch(
                {{
                    set.seed(42)

{self.submission}

                    #suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "{self.submission_img}"
                        )
                    #)
                    #suppressWarnings(
                        ggplot_build(last_plot())
                    #)
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
        print("Running evaluation2...")
        result = subprocess.run(
            [
                "podman", "run",
                "--rm", # remove container upon exit
                "--network", "none", # don't enable network connectivity
                "--memory", "512m",
                "--cpus", "1",
                "--tmpfs", "/tmp",
                "--volume", f"{os.path.abspath('scripts')}:/sandbox/scripts:ro",
                "--volume", f"{os.path.abspath('figures')}:/sandbox/figures:rw",
                "r-eval", # image name
                "Rscript", f"/sandbox/scripts/{os.path.basename(self.script_name)}" # command
            ],
            capture_output=True,
            text=True,
            timeout=30
        )
        return(result)
