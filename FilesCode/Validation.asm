#Prachi Kambli
# 11/30/2016
# checks whether the input is a valid input, and also part of the word bank

.data
# MAIN DATA COMPONENTS
	# input: .asciiz "py\0"
	# middleChar: .ascii  "A"
	# wordBankLength: .word 5
	# wordBank: .ascii "0\0########","0\0########","0\0########", "0\0########", "0\0########"

# VERIFY STRINGS
	# invalidLengthWarning: .asciiz "Invalid length.\n"
	# noMiddleLetterWarning: .asciiz "Does not have middle letter.\n"
	# wordValidMessage: .asciiz  "Word is valid.\n"
	# wordInvalidMessage: .asciiz "Word is invalid.\n"	
	

.text
validation:
	# Save $ra to stack
	subi $sp, $sp, 4
	sw $ra, 4($sp)
	
	#first checks whether the input is a valid length
	la $a0, input
	jal length
	
	slti $t1, $v0, 4
	bnez $t1,notValidLength
	
	bgt $v0, 9, notValidLength
	
	#checks if the input has the middleChar
	 lb $a1, middleChar		#loads the char
    	 addi $a1, $a1, 32		#converts it into lowercase (since its assummed the input is lowercase)
    	 li $t0, 0		
    	 sb $a1, middleChar($t0)	#Stores the char back into the middleChar
	
	#checks whehter the input contains the mid letter
   	 la $a0, input	#loads the adress of the input 
   	 jal containsMid	#jumps and links to the containsMid method
   	 
   	 #if the value returns 
   	 #zero it does contain the mid letter 
   	 #if not it doesnt contain teh mid letter and goes to doesNotContainMid
   	 lb $a1, middleChar		#loads the char
    	 subi $a1, $a1, 32		#converts it into lowercase (since its assummed the input is lowercase)
    	 li $t0, 0		
    	 sb $a1, middleChar($t0)	#Stores the char back into the middleChar
	
   	 bne $v0,$zero,doesNotContainMid   
	 
	 la $a3, wordBank		#loads the adress of the first element in the wordbank
	 lw $t6, wordBankLength	#loads the length of the word Bank
	 jal validateSetup		#checks if the first word is valid
label: 
	bne $v0, $0, exitFound	#if the value of $v0 is zero 
				#it has found the word in the list and goes to exitFound, else it continues 
	beqz $t6, exit		#if it is at the end of an array goes to exit
	addi $a3, $a3, 10		#add the address by 10 (going to the next element)
	subi $t6, $t6, 1		#subtract the counter by one (the counter is going from high to low)
	jal validateSetup		#check if that word is valid
	j label

validateSetup: 
	 #converts the middle character to lowercase and stores it back in char
	 subi $sp, $sp, 4	#creates space for the ra at the  stack pointer
	 sw $ra, 4($sp)	#stores the ra in the space
	 
validate:
 	#checks whether the input and the word in the array are the same or not.
   	 la $a0, input	#stores the address in the input 
    	 jal sameInput	#jumps to check if the strings are the same
    	  
    	 lw $ra, 4($sp)	#restores the ra from the stack
   	 addi $sp,$sp,4 
    	  
    	 # if the $v0 returns 1 it is the same word, if not it is an invalid word. 
    	 bne $v0, $zero, notSame	#if the value is 1 the strings are not the same
    	 li $v0, 4		#else it loads the address of $v0 onto 4
    	 la $a0, wordValidMessage	#prints the word is valid
    	 syscall
    	 addi $v0, $zero, 1		#returns 1 which means the word is valid 
    	 
    	 lw $s0, score	# Load score
    	 addi $s0, $s0, 100 # Increment by 100
    	 sw $s0, score	# Save score
    	 
    	 j endMethod
    	 
#-------------------------------------------Looping Methods--------------------------------
	 	 
#method for checking whether the value has a mid letter
containsMid:
	add $t0, $zero,$zero 
	add $t1, $zero, $a0   #stores $a0 to @t1
	lb $t2, middleChar	  #stores the middle Character
	
validationLoop:  
    	lb $t3($t1)           #load a byte from each string  
   	beqz $t3,missmatch    #str1 end  
    	sub $t5, $t2, $t3     #subtracts the diffrence between the two 
    	beqz $t5, check       #if the value is the same, it returns true
    	addi $t1,$t1,1        #t1 points to the next byte of str1   
    	j validationLoop  

missmatch:   
    	addi $v0,$zero,1  
    	j endMethod
    	
check:   
    	add $v0,$zero,$zero  
	j endMethod
	
#finds the length of the string
length:
	add $t0, $zero, $zero
	add $t1, $zero, $a0
	add $v0, $zero, $zero
	
	li $t4, '\n'
	
validationLoop3:
	lb $t3($t1)	#loads the byte
	beqz $t3, endMethod #checks whether its empty, if so end the method
	beq $t3, $t4, endMethod	#checks for the nextline, if so end the method	
	addi $v0, $v0, 1	#adds the counter to the length $v0
	addi $t1, $t1, 1	#points to the next byte
	j validationLoop3
   	
# sameInput method, checks whether the method is the same as the value in the array. 		
sameInput: 
	add $t0, $zero, $zero
	add $t1, $zero, $a0
	add $t2, $zero, $a3
	
	li $t6, '\n'
	
validationLoop2:
	lb $t3($t1)	#loads a byte from the input
	lb $t4($t2)  	#loads a byte from the string from the array
    	beq $t3, $t6, checkt2    #str1 end   go to checkt2
   	beq $t4, $t6, missmatch2 #str2 end go tto mismatch
  	slt $t5,$t3,$t4     #subtracts the two bytes.  
   	bnez $t5,missmatch2 # if it is not equal to zero, that means its not the same character hence returning false.
    	addi $t1,$t1,1      #t1 points to the next byte of str1  
    	addi $t2,$t2,1
    	j validationLoop2 
    	
missmatch2:   
    	addi $v0,$zero,1   #not the same string returns 1
    	j endMethod  
    	
checkt2:  
   	bnez $t4,missmatch2  #checks fi the length of the two are the same
   	add $v0,$zero,$zero  #if true returns 0 
   	
#end method function
endMethod:
   	jr $ra
   	
#-------------------Invalid input labels--------------------------

#the error message for the length being invalid.
notValidLength: 
	 li $v0,4  
    	 la $a0, invalidLengthWarning
    	 syscall 
    	 addi $v0, $0, 0
    	 j exit
    	 
#end message for when its not in the list
notSame:
	addi $v0, $0, 0
	j endMethod
	
#end message if it doesnt contain the mid letter  	   	 
doesNotContainMid:  
   	 li $v0,4  
    	 la $a0, noMiddleLetterWarning
    	 syscall 
    	 addi $v0, $0, 0
    	 j exit
    	 
#stores *\n in the array, making the word now invalid
exitFound:
	li $t7, '*'	
	li $t8, '\n'
	sb $t7, ($a3)	
	sb $t8, 1($a3)
	
	# Restore $ra
	lw $ra, 4($sp)		
	addi $sp, $sp, 4
			
	jr $ra
#exits out if its an invalid input, displays the invalid message
exit:  
	li $v0, 4
	la $a0, wordInvalidMessage
	syscall
	
	# Restore $ra
	lw $ra, 4($sp)		
	addi $sp, $sp, 4
	
   	jr $ra
