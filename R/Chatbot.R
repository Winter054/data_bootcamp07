## HW01: Create chatbot with 5 dialogues
## Here's my lovely catto.
savagecatbot <- function() {
  print("Meoww!")
  name <- readline("What's your name meow? : ")
  print(paste("Nice to meow you.", name))
  
  ## Use while loop to have endless talk.
  while (TRUE) {
    talk <- as.numeric(readline("Which one do you like: Cat[1] Dog[2] or Leave[3]"))
  
    if (talk == 3) {
      print(paste("Bye bye, ", name))
      break
    } 
    
    else if (talk == 1) {
      print(paste("Nice one! you can be my loyal servant,", name, "What if you have to pick again?"))
    } else if (talk == 2) {
      print(paste("What did you just say?", name, "I don't think I like your attitude."))
    }
  }
}