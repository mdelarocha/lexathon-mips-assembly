#Prachi Kambli
# 12/1/2016
# Prints out the grid 
.data
	
	#middleCharIndex: .word 3
	#middleChar: .byte 'C'
	byte: .byte '#'
	
	#tiles: .asciiz "ABSCONDED"
	#	     "CBSAONDED"
	#gridTemplate: .asciiz "\n\t + - + - + - +\n\t | # | # | # | \n\t + - + - + - +\n\t | # | # | # | \n\t + - + - + - +\n\t | # | # | # | \n\t + - + - + - +\n\n"
	#grid: .asciiz "\n\t + - + - + - +\n\t | # | # | # | \n\t + - + - + - +\n\t | # | # | # | \n\t + - + - + - +\n\t | # | # | # | \n\t + - + - + - +\n\n"
	
.text
gridDisplay:
	subi $sp, $sp, 4	# Save $ra
	sw $ra, 4($sp)

	la $a0, tiles
	lw $a1, middleCharIndex
	lb $a2, middleChar
	la $a3, grid
	
	jal moveCharToFront
	
	sb $a2, 58($a3)
	
	la $a0, tiles
	jal addChars
	
	jr $ra
	
moveCharToFront:
	la $a0, tiles
	lw $t0, middleCharIndex
	lb $t1, tiles

	sb $a2, 0($a0)
	add $a0, $a0, $t0
	sb $t1, 0($a0)
	
	add $t1, $zero, $zero
	sw $t1, middleCharIndex
	
	jr $ra
addChars:
	add $t0, $zero, $a0
	addi $t0, $t0,1
	
	lb $t1($t0)
	addi $t0, $t0,1
	sb $t1 21($a3)
	
	lb $t1($t0)
	addi $t0, $t0,1
	sb $t1 25($a3)
	
	lb $t1($t0)
	addi $t0, $t0,1
	sb $t1 29($a3)
	
	lb $t1($t0)
	addi $t0, $t0,1
	sb $t1 54($a3)
	
	lb $t1($t0)
	addi $t0, $t0,1
	sb $t1 62($a3)
	
	lb $t1($t0)
	addi $t0, $t0,1
	sb $t1 87($a3)
	
	lb $t1($t0)
	addi $t0, $t0,1
	sb $t1 91($a3)
	
	lb $t1($t0)
	addi $t0, $t0,1
	sb $t1 95($a3)
	
	lw $ra, 4($sp)		# Reload $ra
	addi $sp, $sp, 4
	
	jr $ra
