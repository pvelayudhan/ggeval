import os
import cohere


# Initialize the client. 
# It will automatically look for the COHERE_API_KEY environment variable.
co = cohere.ClientV2()

# Define your chat history/prompt
messages = [
    {
        "role": "user", 
        "content": "What are the core differences between Command R and Command R+?"
    }
]

print("Sending request to Cohere...")

response = co.chat(
    model="command-a-plus-05-2026",
    messages=messages
)

print("\n--- Cohere Response ---")
print(response.message.content[0].text)
