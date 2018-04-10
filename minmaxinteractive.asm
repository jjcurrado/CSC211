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

loop:   
        lw $t4,($t0)        # t4 = next element in array
        bge $t4,$t2,notMin  # if array element is  >= min goto notMin

        move $t2,$t4        # min = a[i]
        j notMax

notMin:
        ble $t4,$t3,notMax  # if array element is <= max goto notMax
        move $t3,$t4        # max = a[i]

notMax: 
        add $t1,$t1,-1      # t1 --  ->  counter --
        add $t0,$t0,4       # increment counter to point to next word
        bgtz $t1,loop
        
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

       la $a0, p4           # Would you like to try again?
       la $v0, 4
       syscall

       la $a0, in
       li $a1, 4
       li $v0, 8
       syscall

       lb $s0, in
       li $s1, 'y'
       beq $s0, $s1, main
EOP:   
        li $v0,10
        syscall

input:  # Input subprogram

        la $a0, p3          # ask for the number of numbers    
        li $v0,4
        syscall

        li $v0,5            # input that number
        syscall
        
        sw $v0,count        # store word in count
        la $t0,array        # initial t0  and t1
        lw $t1,count
        
inloop: 

        beqz $t1,endloop    # if count has reached 0 end loop

        li $v0,5            # use a loop to enter the numbers into the array
        syscall
        sw $v0,($t0)        # store input into current address of array 

        addi $t1,$t1,-1      # decrement the count 
        addi $t0, $t0, 4    # move to next address

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

outputloop:

        beqz $t1, endoutloop

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
        addi $t0, $t0, 4

        # t1=t1-1
        addi $t1, $t1, -1

        # if t1=0 endoutloop
        j outputloop

endoutloop:

        la $a0,crlf         # Display "cr/lf"
        li $v0,4            # a0 = address of message
        syscall             # v0 = 4 which indicates display a string

        # return to instruction after instruction jal output
        jr $ra
        

        .data
array:  .space 400
space:  .asciiz "   "
count:  .word 0
p1:     .asciiz "The minimum number is "
p2:     .asciiz "\nThe maximum number is "
p3:     .asciiz "\nHow many numbers would you like to enter?: "
p4:     .asciiz "\nWould you like to continue (y,n)?"                        # student create
crlf:   .asciiz "\n"
in:  .space  4 

################ Output ###################
#                                         
# 1 How many numbers would you like to enter?: 3
#  2 1
#  3 2
#  4 3
#  5
#  6 1   2   3
#  7 The minimum number is 1
#  8 The maximum number is 3
#  9
# 10 Would you like to continue (y,n)?y
# 11
# 12 How many numbers would you like to enter?: 4
# 13 -1
# 14 2
# 15 49
# 16 100
# 17
# 18 -1   2   49   100
# 19 The minimum number is -1
# 20 The maximum number is 100
# 21
# 22 Would you like to continue (y,n)?y
# 23
# 24 How many numbers would you like to enter?: 2
# 25 100
# 26 100000
# 27
# 28 100   100000
# 29 The minimum number is 100
# 30 The maximum number is 100000
# 31
# 32 Would you like to continue (y,n)?n
#                                         
#################################################

