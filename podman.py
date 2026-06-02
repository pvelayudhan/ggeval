import subprocess

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
        "Rscript", "/sandbox/eval_run.R" # command
    ],
    capture_output=True,
    text=True,
    timeout=30
)
