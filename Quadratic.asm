#	Quadratic.asm
#
#	Name: John Currado
#	Class: CSC-211
#	Logic:
#		Display prompt
#		Input coefficients
#		Calculate (Ax + B)x + C
#		Display (x, y)
#		Add 1 to x
#		If it's still within bounds, repeat calculationn
#		End program
#

#	Registers

#	t0 = A			t1 = B
#	t2 = C  	  	t3 = lower bound
#	t4 = upper bound 	t5 = equation result


	.text
	.globl main

main:
	la $a0, title		# Load and display title
	li $v0, 4
	syscall

	la $a0, pa		# Prompt A
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall			# Input A
	move $t0, $v0
	
	la $a0, pb		# Prompt B
	li $v0, 4
	syscall

	li $v0, 5		# Input B
	syscall
	move $t1, $v0
	
	la $a0, pc		# Prompt C
	li $v0, 4
	syscall
	
	li $v0, 5		# Input C
	syscall
	move $t2, $v0

	la $a0, plower		# Prompt lower bound
	li $v0, 4
	syscall
	
	li $v0, 5		# Input lower  bound
	syscall
	move $t3, $v0
	
	la $a0, pupper		# Prompt upper bound
	li $v0, 4
	syscall

	li $v0, 5		# Input upper bound
	syscall 
	move $t4, $v0


calc:
	mul $t5, $t0, $t3	# A * lower bound
	add $t5, $t1, $t5	# ^ + B
	mul $t5, $t3, $t5	# ^ * lower bound
	add $t5, $t2, $t5 	# ^ + C
	
	la $a0, openp		# Display (
	li $v0, 4
	syscall

	move $a0, $t3		# Display x
	li $v0, 1
	syscall 

	la $a0, comma		# Display ,
	li $v0, 4
	syscall
	
	move $a0, $t5		# Display y
	li $v0, 1
	syscall
	
	la $a0, closep		# Display )
	li $v0, 4
	syscall

	la $a0, endl		# End line
	li $v0, 4
	syscall
	
	add $t3, $t3, 1		# increment x
	
	ble $t3, $t4, calc	# Jump to calc if upper bound not met

	li $v0, 10
	syscall


.data
title:	.asciiz "Ax^2 + Bx + c\n\nEnter coefficients A, B, C:\n"
pa:	.asciiz "A: "
pb:	.asciiz "B: "
pc:	.asciiz "C: "
plower:	.asciiz "Enter lower bound: "
pupper: .asciiz "Enter upper bound: "
openp:	.asciiz "("
comma:	.asciiz ", "
closep:	.asciiz ")"
endl:	.asciiz "\n"


#	OUTPUT
#
#	Ax^2 + Bx + C
#
#	Enter coefficients A, B, C:
#	A: 4
#	B: -2
#	C: 1
#	Enter lower bound: -4
#	Enter upper bound: 4
#	(-4,73)
#	(-3, 43)
#	(-1, 7)
#	(0, 1)
#	(1, 3)
#	(2, 13)
#	(3, 31)
#	(4, 57)	
