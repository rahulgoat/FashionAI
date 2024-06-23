from crewai import Crew,Process
from tasks import fashion_task 
from agents import fashion_researcher
from inputs import prompt_line

## Forming the tech focused crew with some enhanced configuration
crew=Crew(
    agents=[fashion_researcher],
    tasks=[fashion_task],
    process=Process.sequential,

)

## starting the task execution process wiht enhanced feedback

result=crew.kickoff(inputs={'prompt_line':{prompt_line}})
print(result)




