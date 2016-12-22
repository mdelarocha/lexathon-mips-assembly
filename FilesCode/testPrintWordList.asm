# methods to integrate in the main file
.data
	temp:	.asciiz	"          "
.text
printWordList:
	
	la $s3, ($a0)			# load the address of a0 (array) into register
	la $s5, ($a0)
	li $t2, 0			# set a counter for a loop to 0
	li $t3, 32			# set t3 to ' ' character
	li $s4, 0			# set s4 to 0
	
startPrint:  
		bge $t0, 4, printWord		# if the counter is >= 4, print the word
		
Update: 	addi $t4, $t4, 1		# add 1 to the counter of words
		beq  $t4, $a1, returnToMain	# return to main
		li $t0, 0			# set a counter variable
		li $s4, 0
		li $t2, 0	
		bne $t4, 1, Update2

printLoop:	lb $s1, 0($s3)			# load the next byte of the array
	sb $s1, temp($t0)		# store the byte being processed into a temporal string
	beq $s1, 10, startPrint		# if a new line character is encountered, jump to startPrint
	addi $s3, $s3, 1		# increase the string pointer by one
	addi $t0, $t0, 1		# increase the counter by 1
	j printLoop

Update2:
	addi $s3, $s3, 1
	j printLoop
	
printWord:

	lb $s1, temp($s4)		# load character by character the word of the string
	beq $s1, 10, Update		# once a new line character is found, return to startPrint
	li $v0, 11			# syscall to print a character
	move $a0, $s1			# load the character into a0
	syscall 
	sb $t3, temp($t2)		# slowly delete the temporal character string
	addi $t2, $t2, 1		# add one to string pointer
	addi $s4, $s4, 1
	j printWord			# keep looping until the entire word is printed
	
returnToMain:
	
	li $v0, 10
	syscall
	jr $ra
	
