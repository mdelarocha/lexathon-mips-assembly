.data
	#tiles: .asciiz "CBSAONDED"
	#temp: .asciiz  "#########"
	
	#middleChar: .byte 'C'
.text

shuffle:
	la $a0, tiles
	la $a1, temp
	
	jal loopSetup
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	la $a0, tiles
	la $a1, temp
	
	add $t0, $0, $a1
	add $t1, $0, $a0
	addi $t1, $t1, 8
	# 1
	lb $t2,($t1)
	subi $t1, $t1, 8
	addi $t1, $t1, 1
	sb $t2, ($t1)
	# 2
	addi $t0, $t0, 1
	lb $t3 ($t0)
	addi $t1, $t1, 1
	sb $t3, ($t1)
	# 3
	addi $t0, $t0, 1
	lb $t3 ($t0)
	addi $t1, $t1, 1
	sb $t3, ($t1)
	# 4
	addi $t0, $t0, 1
	lb $t3 ($t0)
	addi $t1, $t1, 1
	sb $t3, ($t1)
	# 5
	addi $t0, $t0, 1
	lb $t3 ($t0)
	addi $t1, $t1, 1
	sb $t3, ($t1)
	# 6
	addi $t0, $t0, 1
	lb $t3 ($t0)
	addi $t1, $t1, 1
	sb $t3, ($t1)
	# 7
	addi $t0, $t0, 1
	lb $t3 ($t0)
	addi $t1, $t1, 1
	sb $t3, ($t1)
	# 8
	addi $t0, $t0, 1
	lb $t3 ($t0)
	addi $t1, $t1, 1
	sb $t3, ($t1)
	
	li $v0, 4
	la $a0, tiles
	syscall
	
	jr $ra
	
loopSetup: 
	add $t4, $zero, $a0
	add $t5, $zero, $a1

randomLoop:
	lb $t6, ($t4)
	beqz $t6, endRandomMethod
	sb $t6,($t5)
	addi $t5, $t5, 1
	addi $t4, $t4, 1
	j randomLoop
endRandomMethod:
	
	jr $ra 

	
	
	
