## HW02: Create Rock, Paper, Scissor games and exit with score count.

## Create counter and moves options.
moves <- c("Rock", "Paper", "Scissors", "Quit")
win <- 0
tie <- 0
loss <- 0 
round <- 0

## While loop
while (TRUE) {
  player_move <- as.numeric(readline("Choose: Rock[1], Paper[2],Scissors[3], Quit[4]"))
  if(player_move == 4) {
    print("Good bye.")
    break
  }

## Sample moves
  player_move <- moves[player_move]
  computer_move <- moves[sample(1:3, 1)]  
  
## Create rules.
  if(player_move == computer_move) {
    tie <- tie+1
  } else if(player_move == "Rock" & computer_move == "Scissors") {
    win <- win+1
  } else if(player_move == "Paper" & computer_move == "Rock") {
    win <- win+1
  } else if(player_move == "Scissors" & computer_move == "Paper") {
    win <- win+1
  } else {
    loss <- loss+1
  }
  
## Print game visual.
  round <- round+1
  print(paste("Round ----- ", round))
  print(paste("Player move: ", player_move))
  print(paste("Comp move: ", computer_move))
  print(paste("Score: ", "Win =", win ,"Tie =", tie, "Loss =", loss))
}