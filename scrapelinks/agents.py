from crewai import Agent
from tools import tool
from dotenv import load_dotenv
load_dotenv()
from langchain_google_genai import ChatGoogleGenerativeAI
from inputs import *
import os


## call the gemini models
llm=ChatGoogleGenerativeAI(model="gemini-1.5-flash",
                           verbose=True,
                           temperature=0.5,
                           google_api_key=os.getenv("GOOGLE_API_KEY"))

# Creating a senior researcher agent with memory and verbose mode

fashion_researcher = Agent(
    role="Fashion Stylist",
    goal=f'Provide personalized outfit recommendations based on {prompt_line}',
    verbose=True,
    memory=True,
    max_iter=5,
    backstory=(
        "With an impeccable sense of style and an eye for detail, you excel"
        " at curating outfits that not only match the occasion but also align"
        " perfectly with personal preferences and trends."
    ),
    tools=[tool],
    llm=llm,
    allow_delegation=True
)
