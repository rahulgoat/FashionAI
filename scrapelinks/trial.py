def get_user_input():
    gender = input("Enter your gender (e.g., Male, Female, Other): ")
    age = input("Enter your age (e.g., 25): ")
    size = input("Enter your size (e.g., Small, Medium, Large, XL): ")
    preferred_fit = input("Enter your preferred fit (e.g., Loose, Tight, Fitted, Regular): ")
    favorite_colors = input("Enter your favorite color(s) (e.g., Blue, Black, Red). Separate multiple colors with commas: ")
    occasion = input("Enter the occasion (optional, e.g., Casual, Formal, Party, Workout): ")
    budget = input("Enter your budget (e.g., 50-100 USD): ")

    user_input = {
        "Gender": gender,
        "Age": age,
        "Size": size,
        "Preferred Fit": preferred_fit,
        "Favorite Color(s)": [color.strip() for color in favorite_colors.split(',')],
        "Occasion": occasion,
        "Budget": budget
    }

    return user_input

def create_prompt_line(user_input):
    prompt_line = (
        f"{user_input['Age']} year old {user_input['Gender']} prefers {user_input['Preferred Fit']} fit "
        f"clothes, usually wears size {user_input['Size']}, loves {', '.join(user_input['Favorite Color(s)'])} colors, "
        f"and has a budget of {user_input['Budget']}."
    )
    if user_input.get('Occasion'):
        prompt_line += f" This recommendation is for a {user_input['Occasion']} occasion."
    return prompt_line

if __name__ == '__main__':
    user_input = get_user_input()
    prompt_line = create_prompt_line(user_input)
    print("\nGenerated Prompt Line:")
    print(prompt_line)


