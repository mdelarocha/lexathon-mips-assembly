# lexathon-mips-assembly
Lexathon Game in MIPS Assembly Language


  Our program is a simulation of the game Lexathon in MIPS assembly language. The game consists of guessing words of lengths 

four to nine from a 9-letter grid in the time of one minute. The more words guessed, the higher the score. 

The game will automatically finish once the user decides to exit the game. Other rules involve the use of the middle 

character of the grid in all guesses, no word of length less than 3 or greater than 9 is permitted, and no guesses may be 

utilized again to gain more points. 


  The MIPS program utilizes a dictionary, where a list consists of a 9 letter word and all possible, legal combinations of words 

with the letters of the 9 lettered word. There are dictionary files as a that contain lists of words, and one list is randomly 

selected from one of the files for the current round being played. When the user inputs a guess, that guess is then validated 

with the list of words and if it matches one of the words of the list, then the user is awarded the points. 

The correct guess then is moved into a list of invalid guesses, since that guess has already been accepted. 

If the guess is not in the word list, then the user is not awarded points, as well as receiving an invalid message. 

After a round is played (when the user exits) the game is over. 
