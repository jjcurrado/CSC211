########### hex.asm on p. 76-78 #############
       .text
       .globl main

main:
        la $a0,prompt   # display prompt on terminal
        li $v0,4
        syscall

        li $v0,5        # read an integer
        syscall

        move $a0,$v0    # and store it in a0 for transfer

        jal hex

        li $v0,10       # eop
        syscall
	
#######################################################################
#  a0 - contains the binary number to be converted to ASCII
#  s0-s3 - used in subprogram hex
#-------------------------------------------------------------
#  s0 - counter for 8 bytes in subprogram
#  s1 - register used to nibble to ASCII character
#  s2 - contains the original binary number as it rotates left
#  s3 - holds the address of result, where the 8 ASCII characters reside
########################################################################
 
hex:    sub $sp,$sp,24  # push registers onto stack
        sw $a0,0($sp)
        sw $s0,4($sp)
        sw $s1,8($sp)
        sw $s2,12($sp)
        sw $s3,16($sp)
        sw $ra,20($sp)

        move $s2,$a0    # transfer argument

        la $a0, ans1    # display the string before result
        li $v0,4
        syscall

        li $s0,8        # eight hex digits in word
        la $s3,result   # answer string set up here

loop:   rol $s2,$s2,4   # start with left most digit
        and $s1,$s2,0xf # mask one digit in s2 and place results in s1
        ble $s1,9,print # is s1 <= 9, if so go to print
        add $s1,$s1,7   # if not add 7 to get to A..F

print:  add $s1,$s1,48  # add 48 (30 hex) to get ascii character
        sb $s1,($s3)    # store the byte in result - (s3) points to result
        add $s3,$s3,1   # s3++
        add $s0,$s0,-1  # s0--
        bnez $s0,loop   # repeat loop as long as s0 != 0
        la $a0,result   # display result on terminal
		
        li  $v0,4
        syscall

        la $a0,endl     # display cr/lf
        li $v0,4
        syscall

        lw $a0,0($sp)   # pop registers from stack
        lw $s0,4($sp)
        lw $s1,8($sp)
        lw $s2,12($sp)
        lw $s3,16($sp)
        lw $ra,20($sp)
        add $sp,$sp,24

        jr $ra          # return

        .data

result: .space 8
endl:   .asciiz "\n"
prompt: .asciiz "Enter decimal number: "
ans1:   .asciiz "The number in hexidecimal is "


################# OUTPUT ################
#                                       #
# Enter decimal number: 10              #
# The number in hexidecimal is 0000000A #
#                                       #
# Enter decimal number: 2001            #
# The number in hexidecimal is 000007D1 #
#                                       #
#########################################
