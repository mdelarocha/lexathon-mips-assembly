# DATA
.data
	# STRINGS
	# MAIN STRINGS
	divider: .asciiz "\n"
	introduction: .asciiz "Welcome to our MIPS assembly language translation of Lexathon.\nWe hope you enjoy playing this just as much as we enjoyed coding it!\n\n"
	rules0: .asciiz "RULES:\n"
	rules1: .asciiz "You will be given 9 tiles with letters in a grid.\nYour objective is to form as many words of length 4 to 9 from the tiles as you can.\nYou MUST use the tile in the center of the grid and CANNOT use any tile more than once. You CANNOT repeat words.\n\n"
	rules2: .asciiz "Here's an example of what you'll be given:"
	rules3: .asciiz "\n\t + - + - + - +\n\t | O | B | S |\n\t + - + - + - +\n\t | C | A | N |\n\t + - + - + - +\n\t | D | E | D |\n\t + - + - + - +\n\n"
	rules4: .asciiz "Here are some examples of what you may enter as words:\n\t DEAD, absconded, AbScOnDed, sand, scab, BACON\n\n"
	rules5: .asciiz "You will also be able to enter prompts in the form of numbers to print the grid, check your score and more.\nWe will tell you about the prompts when they become available. \nYou may also check them by entering 1 during a round.\n\n"
	promptUserToWait: .asciiz "\nPlease wait while we set up the round.\n"
	promptUserToRedo: .asciiz "Your input was invalid. Please try again.\n"
	promptUserGame: .asciiz "Enter 9 to start a round or 0 to quit game.\n"
	endGameMessage: .asciiz "Thanks for playing!\n"
		
	# ROUND STRINGS
	playingRoundAnnouncement: .asciiz "\nYou have begun a round.\n"
	playingRoundInformation: .asciiz "Your tiles for this round are:\n"
	promptUserDuringRound: .asciiz "\nEnter a word or 1 to see all prompts you may enter.\n"
	duringRoundPrompts: .asciiz "\nThe during round prompts are as follows:\n\t1 to print prompts\n\t2 to print the grid of letters\n\t4 to print the score\n\t7 to print the rules\n\t9 to end the round\n\n"
	scoreTailer: .asciiz " is your score.\n\n"
	endingRoundAnnouncement: .asciiz "You have ended the round.\n"
	promptUserEndingRound: .asciiz "Enter 1 to see all prompts you may enter.\n"
	endRoundPrompts: .asciiz "The end round prompts are as follows:\n\t1 to print prompts\n\t0 to end the game\n"
	validWordsEnteredHeader: .asciiz "\nValid words entered:\n"
	invalidWordsEnteredHeader: .asciiz "\nInvalid words entered:\n"
	validWordsUnenteredHeader: .asciiz "Valid words not yet entered:\n"
	
	# VERIFY STRINGS
	invalidLengthWarning: .asciiz "Invalid length.\n"
	noMiddleLetterWarning: .asciiz "No middle letter.\n"
	wordValidMessage: .asciiz  "Word is valid.\n"
	wordInvalidMessage: .asciiz "Word is invalid.\n"	
	
	# VARIABLES	
	# ROUND VARIABLES
	wordBank: .space 500000 # Segment to hold the correct words for the round
	wordBankLength: .word 0

	#invalidWordsEntered: .space 500000
	#invalidWordsEnteredLength: .word 0
	#validWordsEntered: .space  500000
	#validWordsEnteredLength: .word 0
	
	nineLetterWord: .asciiz "#########"
	middleCharIndex: .word 0
	middleChar: .byte '#'
	middleCharTemp: .byte 'A'
	
	tiles: .asciiz "#########"
	gridTemplate: .asciiz "\n\t + - + - + - +\n\t | # | # | # | \n\t + - + - + - +\n\t | # | # | # | \n\t + - + - + - +\n\t | # | # | # | \n\t + - + - + - +\n\n"
	grid: .asciiz "\n\t + - + - + - +\n\t | # | # | # | \n\t + - + - + - +\n\t | # | # | # | \n\t + - + - + - +\n\t | # | # | # | \n\t + - + - + - +\n\n"
	
	input: .asciiz "##########"
	score: .word 0

.text
.globl main
# Include other .asm files
.include "FileIO.asm"
.include "Validation.asm"

.include "GridDisplay.asm"
#.include "random.asm"

.include "testPrintWordList.asm"

# MAIN METHOD
main:
startGame:
	li $v0, 4		# Print introduction
	la $a0, introduction
	syscall
	
	jal printRules		# Print rules
	
promptLoop:	# Keep asking user to play round or quit
		# until they input valid prompt
	li $v0, 4		# Request prompt 
	la $a0, promptUserGame	
	syscall
	
	li $v0, 5		# Read input as integer
	syscall
	
	beq $v0, 9, startRound 	# If input is 9, start round
	beq $v0, $0, endGame	# If input is 0, end game

				# Else,  
	li $v0, 4		# Tell user input invalid
	la $a0, promptUserToRedo	
	syscall
	
	j promptLoop
	
startRound:	
	li $v0, 4		# Tell user to wait while file is loaded
	la $a0, promptUserToWait
	syscall
		
	j fileIO		# Jump to file IO

continueRound:
				# Fall and continue

	jal gridDisplay

	li $v0, 4		# Print playing round header	
		la $a0, playingRoundAnnouncement
		syscall
		la $a0, playingRoundInformation
		syscall
		la $a0, grid
		syscall
		
inputLoop:
	li $v0, 4	# Request input
	la $a0, promptUserDuringRound	
	syscall
	
	li $v0, 8	# Read input
	la $a0, input
	li $a1, 11
	syscall
	
	lb $t0, input
	
	# Switch statement
	beq $t0, '8', inputInvalid	# Since 8 has no prompt associated with it,
					# input is invalid
	beq $t0, '0', inputInvalid
	beq $t0, '3', inputInvalid
	beq $t0, '6', inputInvalid
	beq $t0, '5', inputInvalid
	
	blt $t0, '0', inputWord		# Since if first character is less than 0, more than 9,
	bgt $t0, '9', inputWord		# It's not numerical and therefore is probably a word
	
	beq $t0, '1', input1
	beq $t0, '2', input2

	beq $t0, '4', input4
	beq $t0, '7', input7
	beq $t0, '9', input9
	
input1:	# Print prompts
	li $v0, 4		
	la $a0, duringRoundPrompts	
	syscall
	
	j inputLoop

input2:	# Print grid
	
	jal gridDisplay
	
	li $v0, 4		# Print grid	
	la $a0, grid	
	syscall
	
	j inputLoop
	
input4:	# Print score
	li $v0, 4		# Print "header"
	la $a0, divider	
	syscall

	li $v0, 1		# Print score	
	lw $a0, score
	syscall
	
	li $v0, 4		# Print tailer
	la $a0, scoreTailer	
	syscall
	
	j inputLoop

input7: # Print rules
	jal printRules
	
	j inputLoop

input9: # End round
	j endRound

inputInvalid:
	li $v0, 4		# Tell user input invalid
	la $a0, promptUserToRedo	
	syscall
	
	j inputLoop
	
inputWord:
	jal validation

	j inputLoop

endRound:
	li $v0, 4		# Print ending round announcement
	la $a0, endingRoundAnnouncement	
	syscall
	
	li $v0, 4		# Print grid
	la $a0, grid	
	syscall
	
	# Print score
	li $v0, 4		# Print "header"
	la $a0, divider	
	syscall

	li $v0, 1		# Print score	
	lw $a0, score
	syscall
	
	li $v0, 4		# Print tailer
	la $a0, scoreTailer	
	syscall
			
endGame:
	li $v0, 4		# Print end game message
	la $a0, endGameMessage	
	syscall

	li $v0, 10
	syscall
	
# PRINT RULES METHOD
printRules:
	li $v0, 4		# Print rules
		la $a0, rules0
		syscall
		la $a0, rules1
		syscall
		la $a0, rules2
		syscall
		la $a0, rules3
		syscall
		la $a0, rules4
		syscall
		la $a0, rules5
		syscall
	
	jr $ra		# Return
