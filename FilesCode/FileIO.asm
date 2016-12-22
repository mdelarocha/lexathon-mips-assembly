#File I/O for the Lexathon Game 
.data
	fileName:		.space  8	# segment to hold the fileName
	wordList:		.space	500000  # segment to hold the entire word list
	roundWords:		.space	500000	# segment to hold the words for the round
	#wordBank:		.space 	500000  # segment to hold the correct words for the round
	wordBuffer:		.asciiz	"         "	# buffer for the current word being used to fill the array
	#tiles:		.asciiz	"         "	# place holder for the letters of the grid
	#middleChar:		.byte	0	# to store the middle character of the grid
	#middleCharIndex:	.word	0	# to store the index of the middle character
	#wordBankLength:		.word	0	# segment to hold the length of the array
	
.text

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Section dealing with File I/O

fileIO: 

randomFile:
	li $a0, 0		# set lower bound to 0
	li $a1, 25		# set upper bound to 4
	li $v0, 42		# syscall for random number in rang 
	syscall
	
	addi $a0, $a0, 65	# add 65 to get in range of ASCII table
	la   $t1, fileName	# load address of fileName
	sb   $a0, ($t1)		# store letter in first byte
	sb   $zero, 1($t1)	# put null terminator at end of file

importFile: 
	
	li $v0, 13		# syscall to open a file
	la $a0, fileName 	# load the filename into a0
	li $a1, 0		# open the file for reading
	li $a2, 0		# modes 0: read, 1: write
	syscall 

	move $s6, $v0		# v0 contains the file descriptor, save it in register s6
	li $v0, 14		# syscall for reading from a file
	move $a0, $s6		# file descriptor into a0 
	la $a1, wordList	# address for a1 to read from the file
	li $a2, 500000		# allocate memory to read in from the file
	syscall
	
	move $t5, $v0		# store the byte count of the file into t5
	
	li $v0, 16		# syscall for closing the file
	move $a0, $s6		# file descriptor to close the file
	syscall
	li $s6, 0		# restore s6

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Section to fill in the wordlist into an array to be used by the game in a round

roundList:

	li $a0, 0		# lower bound for random integer
	li $a1, 100000		# upper bound for random integer
	li $v0, 42		# sycall for random integer in range
	syscall
	
	rem $a0, $a0, $t5
	addi $a0, $a0, -100
	li $t5, 0
	
	addi $sp, $sp, -4	# allocate the stack
	sw   $ra, ($sp)		# save the return address
	jal findFirstWord	# jump and link to find the first word of the round
	lw   $ra, ($sp)		# restore the return address
	addi $sp, $sp, 4	# restore the stack
	
	addi $sp, $sp, -4	# allocate the stack
	sw   $ra, ($sp)		# save the return address
	move $a0, $v0		# move the position of the file (first word) as an argument
	li   $v0, 0		# reset v0
	jal findBaseWord	# get the position for the nine letter word in v0
	lw   $ra, ($sp)		# restore the return address
	addi $sp, $sp, 4	# restore the stack
	
	addi $sp, $sp, -4	# allocate the stack
	sw   $ra, ($sp)		# save the return address
	move $a0, $v0		# move the position of the nine letter word as an argument in a0
	jal fillRoundList	# jump and fill the word array for the current round
	lw  $ra, ($sp)		# restore the return address
	addi $sp, $sp, 4	# restore the stack
	
	addi $sp, $sp, -4	# allocate the stack
	sw   $ra, ($sp)		# save the return address
	jal  getGridLetters	# jump to the label that will get the letters for the round from the 9 lettered word
	lw  $ra, ($sp)		# restore the return address
	addi $sp, $sp, 4	# restore the stack
	
	addi $sp, $sp, -4	# allocate the stack
	sw   $ra, ($sp)		# save the return address
	jal  getMiddleChar	# jump to get the middle char for the grid
	lw   $ra, ($sp)		# restore return address
	addi $sp, $sp, 4	# restore the stack
	
	j Next			# jump to print the grid with the current round
	
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Section to search a random word in the file, then search for the next 9 letter word in the file
# in order to create the word list for the current round. Also finding a middle character for the grid
	
findFirstWord: 
	
	lb $t0, wordList($a0)		# load byte to the position a0 is set to
	beq $t0, 10, returnFirst	# return the first word once a newline character is found
	addi $a0, $a0, 1		# keep adding 1 to a0 until the next newline character
	j findFirstWord

returnFirst:
	
	addi $a0, $a0, 1		# add 1 to a0 in order to start to a new line
	move $v0, $a0			# save the position of the new word into v0
	jr $ra				# return to saved address in the roundList since a word is found
	
findBaseWord:
	
	beq $v0, 10, returnBaseWord	# return once a nine letter word is found
	j   getStringLengthNine		# keep jumping until a nine letter word is found
	
returnBaseWord: 
	
	addi $a0, $a0, -10		# make a0 point to the start of the 9 letter word
	move $v0, $a0			# save the position of the nine letter word in v0
	jr   $ra			# return to the call in the roundList label	

getStringLengthNine: 
	
	li $a2, 0			# initialize a counter to 0
	
loop:	lb $a1, wordList($a0) 		# loop to get the length of the current word
	beq $a1, 10, returnLength	# return length until the counter reaches a newline character
	addi $a0, $a0, 1		# increment string pointer by 1
	addi $a2, $a2, 1		# increment counter by 1
	j loop				# return to the top of the loop

returnLength: 
	
	addi $a0, $a0, 1		# increment the pointer of a0 by 1 to get to point to a new line
	addi $a2, $a2, 1
	move $v0, $a2			# once the counter is 10, it signifies a word of length 9 + new line character
	j findBaseWord			# return to findBaseWord label and the labels will repeat until a nine letter word is found

getGridLetters:

	li $a0, 0			# set argument value to 0
	
loop2:	
	lb  $t1, wordBank($a0)		# first word of the word bank is the nine letter word, load each character at a time
	beq $t1, 10, returnGridLetters	# once the newline is found, return to original call
	sb  $t1, tiles($a0)	# store it to the round letters
	addi $a0, $a0, 1		# move the string pointer by one each iteration
	j loop2				# keep looping until the entire word is stored

returnGridLetters:

	jr $ra
	
getMiddleChar:

	li $a0, 0			# Generate a random number in between 0-9 to get middle character
	li $a1, 9
	li $v0, 42
	syscall
	
returnMiddleChar:
	
	lb $s0, tiles($a0)	# load the letter at the indexed place
	sw $a0, middleCharIndex($zero)	# store the index of the letter in data
	sb $s0, middleChar($zero)	# store the middle char in data
	jr $ra
	
	
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Section to fill the word list based on finding a nine letter word and running through the list
# until the next asterisk is found, signifying the end of the list of the current round

fillRoundList:

	li $a1, 0 # position in the words for the Round
	li $a2, 0 # position for the words being read
	
fillWordBank:

	lb $t0, wordList($a0) 		# load current char on position by a0
	beq $t0, 42, returnRoundList 	# found end of the word list by '*' return
	sb  $t0, wordBuffer($a2) 	# save character to wordBuffer, even the newline character
	beq $t0, 10, saveWordtoRound	# when a new line character is found, save the word into the list
	add $a2, $a2, 1 		# move to next position in wordBuffer
	add $a0, $a0, 1 		# move to next position in wordList
	j fillWordBank

returnRoundList:

	li $a2, 0			# reset a1 to 0
	addi $s1, $s1, -1
	sw $s1, wordBankLength($a2)	# store the count of the words of the array into the Length 
	jr $ra				# return to original call in the roundList
		
saveWordtoRound:

	addi $s1, $s1, 1		# counter for the amount of words being stored into the array
	mul $t2, $a1, 10 		# t2 stores the position of the current word being processed
	li $a2, 0			# reset wordBuffer position to 0
	li $t4, 32 			# load a ' ' char into t4 to process the current word
	
loop3:	lb $t3, wordBuffer($a2)		# load char at current position, and start a loop to store the word
	beq $t3, 0, saveWordEnd 	# reached end of wordBuffer return by reaching null
	sb $t3, wordBank($t2)    	# copy to correctWords at current position
	sb $t4, wordBuffer($a2)		# copy into the wordBuffer the current position a blank character to reset the buffer
	add $t2, $t2, 1			# increment the position of the current word by 1
	add $t3, $t3, 1			# keep incrementing the position by 1
	add $a2, $a2, 1			# increment the position of the correct word being saved by one
	j loop3
			
saveWordEnd:

	li $a2, 0			# reset current word position to 0
	add $a1, $a1, 1 		# move to next position in the list of the Round
	add $a0, $a0, 1 		# move to next position in the general wordList
	j fillWordBank			# continue filling up the word bank array
	
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
Next:
	j continueRound
