#	Name: John Currado
#	Class: CSC211
#	Logic:
#			-	Prompt for variables
#			-	Compute quadratic formula solution
#			+	Draw
#				-	if the current x value is 
#					a solution, the x-axis, or y-axis
#					draw corresponding character
#				-	else draw a space
#				-	if at xmax, start a newline and 
#					reset xcounter
#			-	Continue Compute-Draw loop until
#				Ymin is reached
#			-	End program
#	Registers Used:
#			
#			t0		A
#			t1		B
#			t2		C
#			t3		lowerx
#			t4		upperx
#			t5		quadratic solution
#			t6		lowery
#			t7		uppery
#			t8		y iterator
#			t9		x iterator

	.text
	.globl main

main:

	la $a0, promptA
	li $v0, 4
	syscall
				# Enter A
	li $v0, 5
	syscall
	move $t0, $v0

	#############
	
	la $a0, promptB
	li $v0, 4
	syscall
				# Enter B
	li $v0, 5
	syscall
	move $t1, $v0

	############

	la $a0, promptC
	li $v0, 4
	syscall
				# Enter C
	li $v0, 5
	syscall
	move $t2, $v0

	############
	
	la $a0, promptXmin
	li $v0, 4
	syscall
				# Enter X min
	li $v0, 5
	syscall
	move $t3, $v0
	i
	############

	la $a0, promptXmax
	li $v0, 4
	syscall
				# Enter X max
	li $v0, 5
	syscall
	move $t4, $v0

	############

	la $a0, promptYmin
	li $v0, 4
	syscall
				# Enter Y min
	li $v0, 5
	syscall
	move $t6, $v0

	############

	la $a0, promptYmax
	li $v0, 4
	syscall
				# Enter Y max
	li $v0, 5
	syscall
	move $t7, $v0
	
	############
	
	move $t8, $t7			# Current y = ymax
	move $t9, $t3			# Current x = xmin

CALC:
	
	#############				
	
	mul $t5, $t0, $t9
	add $t5, $t5, $t1		# Quadratic Formula
	mul $t5, $t5, $t9
	add $t5, $t5, $t2

	#############				

	
	beq $t8, $t5, POINT		# Function result = current posistion 
	beqz $t9, YAXIS			# Current x = 0, draw y-axis
	beqz $t8, XAXIS			# Current y = 0, draw x-axis
	
	la $a0, space			# None of the above, so draw a space
	li $v0, 4
	syscall

	beq $t9, $t4, NEWLINE		# Current x = xmax
	add $t9, $t9, 1

	j CALC

POINT:

	la $a0, asterick
	li $v0, 4
	syscall
	beq $t9, $t4, NEWLINE 		# Current x = xmax
	
	add $t9, $t9, 1
	j CALC
	

YAXIS:

	la $a0, yaxis
	li $v0, 4
	syscall
	beq $t9, $t4, NEWLINE
	
	add $t9, $t9, 1
	j CALC

XAXIS:

	la $a0, xaxis
	li $v0, 4
	syscall
	beq $t9, $t4, NEWLINE
	
	add $t9, $t9, 1
	j CALC

NEWLINE:
	
	la $a0, endl
	li $v0, 4
	syscall

	beq $t8, $t6, EOP		# Current y = y min, end program
	sub $t8, $t8, 1			# Decrement current y value
	move $t9, $t3
	j CALC
	
	
EOP:
	li $v0, 10		# EOP
	syscall

.data
promptA:	.asciiz	"Enter A: "
promptB:	.asciiz "Enter B: "
promptC:	.asciiz "Enter C: "

promptXmin:	.asciiz "Enter Lower Bound for X: "
promptXmax:	.asciiz "Enter Higher Bound for X: "
promptYmin:	.asciiz "Enter Lower Bound for Y: "
promptYmax:	.asciiz "Enter Higher Bound for Y: "

asterick:	.asciiz "*"
yaxis:		.asciiz "|"
xaxis:		.asciiz "-"
space: 		.asciiz " "
endl:		.asciiz "\n"

#	OUTPUT:

#	Enter A: 1
#	Enter B: -1
#	Enter C: -6
#	Enter Lower Bound for X: -10
#	Enter Higher Bound for X: 10
#	Enter Lower Bound for Y: -10
#	Enter Higher Bound for Y: 10
#	          |          
#	          |          
#	          |          
#	          |          
#	       *  |   *      
#	          |          
#	          |          
#	          |          
#	          |          
#	          |          
#	--------*-|--*-------
#	          |          
#	          |          
#	          |          
#	         *| *        
#	          |          
#	          **         
#	          |          
#	          |          
#	          |          
#	          |          
