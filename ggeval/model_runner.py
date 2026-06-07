from transformers import AutoModelForCausalLM, AutoTokenizer
from transformers import MistralCommonBackend
from transformers import Mistral3ForConditionalGeneration
import torch
import time
import re
import cohere
from google import genai
from google.genai import types


class ModelRunner:
    def __init__(self, model_name, device_map="cpu"):
        self.model_name = model_name
        print(f"Loading model: {model_name}")

        if self.model_name.startswith("command-a-plus"):
            self.client = cohere.ClientV2
        elif self.model_name.startswith("gemini"):
            self.client = genai.Client()
        else:
            if self.model_name.startswith("mistral"):
                self.tokenizer = MistralCommonBackend.from_pretrained(
                    self.model_name
                )
                self.model = Mistral3ForConditionalGeneration.from_pretrained(
                    self.model_name,
                    dtype="auto",
                    device_map=device_map
                )
            else:
                self.tokenizer = AutoTokenizer.from_pretrained(self.model_name)
                self.model = AutoModelForCausalLM.from_pretrained(
                    self.model_name,
                    dtype="auto",
                    device_map=device_map
                )

    def _strip_thinking(self, text):
        return re.sub(r"<think>.*?</think>", "", text, flags=re.DOTALL).strip()

    def _strip_fences(self, text):
        return re.sub(r"```[rR]?", "", text).strip()

    def _strip_code(self, text):
        return re.sub(r"</?code>", "", text)

    def _parse_text(self, text):
        text = self._strip_thinking(text)
        text = self._strip_fences(text)
        return text

    def generate(self, prompt, max_new_tokens=512):
        messages = [{"role": "user", "content": prompt}]

        if self.model_name.startswith("command-a-plus"):
            response = self.client.chat(
                model=self.model_name,
                messages=messages
            )
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
            response_raw = self.client.models.generate_content(
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
                enable_thinking=False,
            )
            start = time.time()
            inputs = inputs.to(self.model.device)
            with torch.inference_mode():
                outputs = self.model.generate(
                    **inputs, max_new_tokens=max_new_tokens, do_sample=False
                )
            latency = time.time() - start
            new_tokens = outputs[0][inputs["input_ids"].shape[-1] :]
            response_raw = self.tokenizer.decode(
                new_tokens, skip_special_tokens=True
            )

        response_parsed = self._parse_text(response_raw)

        return {
            "response_raw": response_raw,
            "response_parsed": response_parsed,
            "latency": latency,
        }
