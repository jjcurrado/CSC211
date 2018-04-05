#	Name:		 	John Currado
#	Class: 		CSC-211
#	Program: 	LS3FP
#	Logic:		1. Prompt for 3 decimal numbers	
#						- set first input to smallest/lowest number	
#	
#					2. Check if any are equal
#						- if so display it
#	
#					3. check second and third inputed numbers against
#						first to see if they are greater or less than
#						- if it is store in respective register
#	
#					4. Display the smallest and largest numbers
#					
#					5. Prompt to continue
#	
#	Registers:
#				
#					$f1 - A
#					$f2 - B
#					$f3 - C
#					$f4 - current smallest number
#					$f5 - current largest number

	.text
	.globl main

main:



##########	Input variables ##########

	la $a0, promptA
	li $v0, 4			#ENTER A
	syscall
	
	li $v0, 6
	syscall
	s.s $f0, A
	
	la $a0, promptB
	li $v0, 4			#ENTER B
	syscall
	
	li $v0, 6
	syscall
	s.s $f0, B
	
	la $a0, promptC
	li $v0, 4			#ENTER C
	syscall
	
	li $v0, 6
	syscall
	s.s $f0, C

#########    End Input     ############


########### Set Registers #########



	l.s $f1, A
	l.s $f2, B
	l.s $f3, C
	
	l.s $f4, A			# Store smallest number (defaults to A)
	l.s $f5, A			# Store largest number (defaults to A)


####################################


########### Check if any values are equal #############



	c.eq.s $f1, $f2	# A = B
	bc1t AEQB

	c.eq.s $f1, $f3	# A = C
	bc1t AEQC

	c.eq.s $f2, $f3	# B = C
	bc1t BEQC

	b BCHECK				# None are equal continue



AEQB:						# A = B

	c.eq.s $f1, $f3	# see if A = C
	bc1t ALLEQ			# if so, branch

	la $a0, aeqb		# output that they are equal
	li $v0, 4
	syscall
	
	b CCHECK				# move on to checking c 



AEQC:						# A = C	
	
	la $a0, aeqc		# output that they are equal
	li $v0, 4
	syscall

	b BCHECK				# continue to check b



BEQC:						# B = C

	la $a0, beqc		# output that they are equal
	li $v0, 4
	syscall

	b BCHECK				# continue to check b 



ALLEQ:					# A = B = C
	
	la $a0, alleq		# output that all are eqal
	li $v0, 4
	syscall

	b PRINT				# jump to displaying results



############################################################


################ Compare values ############################


BCHECK:


	c.lt.s $f2, $f4	# B <  SMALLEST?
	bc1t BLTS			# Yes? : set as smallest, continue


	c.lt.s $f5, $f2	# B > LARGEST
	bc1t BGTL			# Yes? : set B as largest, continue

	b CCHECK



BLTS:						# b < smallest (a)

	mov.s $f4, $f2		# B is the new smallest
	b CCHECK				# Move on to C


BGTL:						# b > largest (a)

	mov.s $f5, $f2		# B is the new largest
	b CCHECK				# Move on to C


###############################################################


CCHECK:


	c.lt.s $f3, $f4	# C <  SMALLEST?
	bc1t CLTS			# Yes? : set C as smallest, continue


	c.lt.s $f5, $f3	# C > LARGEST
	bc1t CGTL			# Yes? : set C as largest, continue

	b PRINT



CLTS:						# C < smallest

	mov.s $f4, $f3		# C is the new smallest
	b PRINT


CGTL:
	mov.s $f5, $f3


##############################################################

PRINT:

	la $a0, smallest			# the smallest number is:
	li $v0, 4
	syscall

	mov.s $f12, $f4			# display smallest number
	li $v0, 2
	syscall

	la $a0, endl
	li $v0, 4
	syscall

	la $a0, largest			# the largest number is:
	li $v0, 4
	syscall

	mov.s $f12, $f5			# display largest number
	li $v0, 2
	syscall

	la $a0, endl
	li $v0, 4
	syscall

	la $a0, continue			# output a continue prompt
	li $v0, 4
	syscall

	la $a0, choice				# input user choice
	li $a1, 4
	li $v0, 8
	syscall

	lb $s0, choice
	li $s1, 'y'
	beq $s0, $s1, main
	
	li $v0, 10					# quit
	syscall				# EOP






	.data

A:.float				0.0
B:.float				0.0
C:.float				0.0


promptA:.asciiz	"Enter A:"
promptB:.asciiz	"Enter B:"
promptC:.asciiz	"Enter C:"

aeqb:.asciiz		"A = B\n"
aeqc:.asciiz		"A = C\n"
beqc:.asciiz		"B = C\n"
alleq:.asciiz		"A = B = C\n"


largest:.asciiz	"The Largest number is:"
smallest:.asciiz	"The Smallest number is:"


endl:.asciiz		"\n"
continue:.asciiz	"Would you like to continue(y,n):"

choice:.space		4


#	Output
#	
#	Enter A:1
#	Enter B:2
#	Enter C:3
#	The Smallest number is:1.00000000
#	The Largest number is:3.00000000
#	Would you like to continue(y,n):y
#	Enter A:1
#	Enter B:3
#	Enter C:2
#	The Smallest number is:1.00000000
#	The Largest number is:3.00000000
#	Would you like to continue(y,n):y
#	Enter A:2
#	Enter B:1
#	Enter C:3
#	The Smallest number is:1.00000000
#	The Largest number is:3.00000000
#	Would you like to continue(y,n):y
#	Enter A:2
#	Enter B:3
#	Enter C:1
#	The Smallest number is:1.00000000
#	The Largest number is:3.00000000
#	Would you like to continue(y,n):y
#	Enter A:3
#	Enter B:1
#	Enter C:2
#	The Smallest number is:1.00000000
#	The Largest number is:3.00000000
#	Would you like to continue(y,n):y
#	Enter A:3
#	Enter B:2
#	Enter C:1
#	The Smallest number is:1.00000000
#	The Largest number is:3.00000000
#	Would you like to continue(y,n):n
