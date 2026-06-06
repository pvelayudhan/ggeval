from transformers import AutoModelForCausalLM, AutoTokenizer
from transformers import MistralCommonBackend
from transformers import Mistral3ForConditionalGeneration
import torch
import time
import re
import cohere
from google import genai
from google.genai import types

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

        if self.model_name.startswith("command-a-plus"):
            pass
        elif self.model_name.startswith("gemini"):
            pass
        else:
            if config.get("tokenizer_class") == "MistralCommonBackend":
                self.tokenizer = MistralCommonBackend.from_pretrained(
                    model_name
                )
            else:
                self.tokenizer = AutoTokenizer.from_pretrained(model_name)

            if config.get("model_class") == "Mistral3ForConditionalGeneration":
                self.model = Mistral3ForConditionalGeneration.from_pretrained(
                    model_name, dtype="auto"
                )
            else:
                self.model = AutoModelForCausalLM.from_pretrained(
                    model_name, dtype="auto"
                )

    def _strip_thinking(self, text):
        return re.sub(r"<think>.*?</think>", "", text, flags=re.DOTALL).strip()

    def _strip_fences(self, text):
        return re.sub(r"```[rR]?", "", text).strip()

    def generate(self, prompt, max_new_tokens=512):
        messages = [{"role": "user", "content": prompt}]

        if self.model_name.startswith("command-a-plus"):
            co = cohere.ClientV2()
            response = co.chat(model=self.model_name, messages=messages)
            response_raw = next(
                (
                    block.text
                    for block in response.message.content
                    if block.type == "text"
                ),
                "",
            )
            latency = 0
            time.sleep(10)  # sleep for API model
        elif self.model_name.startswith("gemini"):
            client = genai.Client()
            response_raw = client.models.generate_content(
                model=self.model_name,
                contents=[
                    types.Content(
                        role=messages[0]["role"],
                        parts=[types.Part(text=messages[0]["content"])],
                    )
                ],
                config=types.GenerateContentConfig(temperature=0),
            ).text
            latency = 0
            time.sleep(10)  # sleep for API model
        else:
            inputs = self.tokenizer.apply_chat_template(
                messages,
                tokenize=True,
                add_generation_prompt=True,
                return_tensors="pt",
            )
            start = time.time()
            with torch.inference_mode():
                outputs = self.model.generate(
                    **inputs, max_new_tokens=max_new_tokens, do_sample=False
                )
            latency = time.time() - start
            new_tokens = outputs[0][inputs["input_ids"].shape[-1] :]
            response_raw = self.tokenizer.decode(
                new_tokens, skip_special_tokens=True
            )

        response_parsed = self._strip_thinking(response_raw)
        response_parsed = self._strip_fences(response_parsed)

        return {
            "response_raw": response_raw,
            "response_parsed": response_parsed,
            "latency": latency,
        }
