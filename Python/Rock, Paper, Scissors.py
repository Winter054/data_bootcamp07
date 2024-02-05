# Rock, Paper, Scissors
# Import random first

import random

def play():
    # Welcome message + Create variables
    print("Welcome to Rock, Paper, Scissors game")
    print("""Enter "Exit" to quit the game.""")
    moves = ["Rock", "Paper", "Scissors"]
    win = 0
    loss = 0
    tie = 0
    round = 0

    while True:
        player_move = str(input("""
        Enter [Rock] [Paper] [Scissors] : """))

        if player_move == "Exit":
            print("""
            Scoreboard: """)
            print("Total round = ", round)
            print("Win = ", win)
            print("Loss = ", loss)
            print("Tie = ", tie)
            print("Win rate =", (win/(round))*100 )
            print("Thanks for playing!")
            break

        comp_move = random.choice(moves)
        print("Player's Move: ", player_move)
        print("Computer's Move: ", comp_move)

        if player_move == comp_move:
            tie += 1
            round += 1
            print("Tie")
        elif player_move == "Rock" and comp_move == "Scissors":
            win += 1
            round += 1
            print("You win!")
        elif player_move == "Paper" and comp_move == "Rock":
            win += 1
            round += 1
            print("You win!")
        elif player_move == "Scissors" and comp_move == "Paper":
            win += 1
            round += 1
            print("You win!")
        else:
            loss += 1
            round += 1
            print("It's your Loss")

