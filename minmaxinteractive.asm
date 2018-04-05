############ minMax.asm on p. 65-66 ##############
#                                                #
# MinMaxInteractive.asm                          #
# Illustrates Base Addressing                    #
#                                                #
# Ask for and Enter an array of numbers,         #
# list the numbers, display the min and max      #
#                                                #
# Ask:  Continue (y/n)?                          #
# If y repeat the program, if n goodbye and EOP. #
#                                                #
# t1 = count, t2 = min, t3 = max                 #
# t0 = counter, t4 = array element               #
# t5 = address of array element, t6 = temp       #
#                                                #
##################################################

        .text
        .globl main
main: 
        jal input           # jump and link to method input
	     jal output          # jump and link to method output       
 
        la $t0,array        # t0 = address of array
        lw $t1,count        # t1 = count, exit loop when it goes to 0
        lw $t2,($t0)        # t2 = min = a[0] (initialization)
        lw $t3,($t0)        # t3 = max = a[0] (initialization)
        add $t0,$t0,4       # move pointer ahead to next array element a[1]
        add $t1,$t1,-1      # decrement counter to keep in step with array

loop:   lw $t4,($t0)        # t4 = next element in array
        bge $t4,$t2,notMin  # if array element is  >= min goto notMin

        move $t2,$t4        # min = a[i]
        j notMax

notMin: ble $t4,$t3,notMax  # if array element is <= max goto notMax

        move $t3,$t4        # max = a[i]

notMax: add $t1,$t1,-1      # t1 --  ->  counter --
        add $t0,$t0,4       # increment counter to point to next word
        bnez $t1,loop

        la $a0,p1           # Display "The minimum number is "
        li $v0,4            # a0 = address of message
        syscall             # v0 = 4 which indicates display a string	

        move $a0,$t2        # Display the minimum number 
        li $v0,1
        syscall

        la $a0,p2           # Display "The maximum number is "
        li $v0,4            # a0 = address of message
        syscall             # v0 = 4 which indicates display a string

        move $a0,$t3        # Display the maximum number 
        li $v0,1
        syscall

        la $a0,crlf         # Display "cr/lf"
        li $v0,4            # a0 = address of message
        syscall             # v0 = 4 which indicates display a string


        # Continue (y/n)
        # if yes, j main
        # if no, say goodbye and EOP
        
EOP:    li $v0,10
        syscall

input:  # Input subprogram

        la $a0, p3     # ask for the number of numbers    
        li $v0,4
        syscall
               
        li $v0,5            # in put that number
        syscall
        
        sw $v0,count        # store word in count
        
        la $t0,array    # initial t0  and t1
        lw $t1,count
        
inloop: li $v0,5            # use a loop to enter the numbers into the array
        syscall
        sw $v0,($t0)        
        add $t1,$t1,-1      # increment the count to keep coun
        add $t0, $t0, 4
        beqz $t1,endloop    # repeat inloop
        j inloop    
               
endloop: 
        la $a0,crlf         # Display "cr/lf"
        li $v0,4            # a0 = address of "crlf"
        syscall             # v0 = 4 which indicates display a string

        jr $ra              # go back to instruction after instruction  jal input

output: # Output subprogram: 
        # Algorithm and student completes the instructions
        
        # initialize t0 and t1 as was done in input
                        
        la $t0,array        # t0 = address of array
        lw $t1,count        # t1 = count, exit loop when it goes to 0
       
        # load a number from the array and display that number
        lw $t2, ($t0)  
        move $a0, $t2

        li $v0, 1
        syscall


        # skip a space
        la $a0, space
        li $v0, 4
        syscall              # skip a space
        
        # t0=t0+4
        add $t0, $t0, 4

        # t1=t1-1
        add $t0, $t0, -1

        # if t1=0 endoutloop
        beqz $t1, endoutloop
        j output

endoutloop:
        # return to instruction after instruction jal output
        jr $ra
        

        .data
array:  .space 100
space:  .asciiz " "
count:  .word 0
p1:     .asciiz "The minimum number is "
p2:     .asciiz "\nThe maximum number is "
p3:     .asciiz "\nHow many numbers would you like to enter?: "
#p4:                         # student create
crlf:   .asciiz "\n"

################ Output ###################
#                                         #
# There may be errors for you to correct. #
# This is due at next class day.          #
# 3 sample runs go here.                  #
#                                         #
###########################################

