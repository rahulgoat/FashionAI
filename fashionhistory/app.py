import os
import google.generativeai as genai
from dotenv import load_dotenv

load_dotenv()  # Take environment variables from .env

# Ensure the API key is set
api_key = os.getenv("GOOGLE_API_KEY")
if api_key:
    genai.configure(api_key=api_key)
else:
    raise ValueError("API key is missing. Please set it in the .env file.")

# Function to load OpenAI model and get responses
def get_gemini_response(input_text, image_path):
    with open(image_path, "rb") as img_file:
        image_data = img_file.read()

    response = genai.generate(
        model="gemini-pro-vision",
        prompts=[input_text],
        images=[image_data],
        generation_config=generation_config,
        safety_settings=safety_settings,
    )
    return response["text"]

# Configuration for the model
generation_config = {
    "temperature": 1,
    "top_p": 0.95,
    "top_k": 64,
    "max_output_tokens": 8192,
    "response_mime_type": "text/plain",
}
safety_settings = [
    {
        "category": "HARM_CATEGORY_HARASSMENT",
        "threshold": "BLOCK_MEDIUM_AND_ABOVE",
    },
    {
        "category": "HARM_CATEGORY_HATE_SPEECH",
        "threshold": "BLOCK_MEDIUM_AND_ABOVE",
    },
    {
        "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
        "threshold": "BLOCK_MEDIUM_AND_ABOVE",
    },
    {
        "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
        "threshold": "BLOCK_MEDIUM_AND_ABOVE",
    },
]

# Provide the correct path to your image file
image_path = '/Users/admin/Downloads/projects/current/FashionAI/fashionhistory/image.png'
initial_input = "Tell what type of fashion is this"

res = get_gemini_response(initial_input, image_path)

extended_input = res + " Give me a brief explanation about this fashion, like why it is famous and many more!"

response2 = get_gemini_response(extended_input, image_path)

print(response2)
