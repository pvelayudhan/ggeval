from transformers import AutoModelForCausalLM, AutoTokenizer
import torch
import time
import re

MODEL_CONFIGS = {
    "mistralai/Ministral-3-3B-Reasoning-2512": {
        "model_class": "Mistral3ForConditionalGeneration",
        "tokenizer_class": "MistralCommonBackend",
    }
}

class ModelRunner:
    def __init__(self, model_name):
        self.model_name = model_name
        config = MODEL_CONFIGS.get(model_name, {})
        print(f"Loading model: {model_name}")

        if config.get("tokenizer_class") == "MistralCommonBackend":
            from transformers import MistralCommonBackend
            self.tokenizer = MistralCommonBackend.from_pretrained(model_name)
        else:
            self.tokenizer = AutoTokenizer.from_pretrained(model_name)

        if config.get("model_class") == "Mistral3ForConditionalGeneration":
            from transformers import Mistral3ForConditionalGeneration
            self.model = Mistral3ForConditionalGeneration.from_pretrained(
                model_name,
                dtype="auto"
            )
        else:
            self.model = AutoModelForCausalLM.from_pretrained(
                model_name,
                dtype="auto"
            )

    def _strip_thinking(self, text):
        return re.sub(r"<think>.*?</think>", "", text, flags=re.DOTALL).strip()

    def _strip_fences(self, text):
        return re.sub(r"```[rR]?", "", text).strip()

    def generate(self, prompt, max_new_tokens=512):
        messages = [{"role": "user", "content": prompt}]
        inputs = self.tokenizer.apply_chat_template(
            messages,
            tokenize=True,
            add_generation_prompt=True,
            return_tensors="pt"
        )
        start = time.time()
        with torch.inference_mode():
            outputs = self.model.generate(
                **inputs,
                max_new_tokens=max_new_tokens,
                do_sample=False
            )
        end = time.time()

        new_tokens = outputs[0][inputs["input_ids"].shape[-1]:]
        response1 = self.tokenizer.decode(new_tokens, skip_special_tokens=True)
        response2 = self._strip_thinking(response1)
        response2 = self._strip_fences(response2)
        return {
            "response-raw": response1,
            "response-parsed": response2,
            "latency": end - start
        }
