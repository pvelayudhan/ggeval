import subprocess
subprocess.check_call(['Rscript', 'evaluate.R'], shell=False)

class Evaluator:
    def __init__(self, answers):
        self.answers = answers
