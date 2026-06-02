import subprocess
p1 = subprocess.run(
    ['Rscript', 'eval_run.R'],
    capture_output=True,
    text=True
)

print(p1)
