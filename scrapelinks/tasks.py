from crewai import Task
from tools import tool
from agents import fashion_researcher


fashion_task = Task(
  description=(
    "Generate personalized outfit recommendations based on user details."
    "Focus on creating stylish and suitable outfits considering the user's preferences, budget, and occasion."
    "Your final recommendation should include a complete outfit with accessories, DON'T GIVE MORE THAN THREE RECOMMENDATIONS"
    "DON'T GIVE MORE THAN THREE RECOMMENDATIONS"
    "highlight the style choices, and explain why each piece was chosen."
  ),
  expected_output='A detailed recommendation including a complete outfit with accessories and explanations for each choice.',
  tools=[tool],
  agent=fashion_researcher,
)

