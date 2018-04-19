##################################################
#  Name:    John Currado
#  Class:   CSC211
#  File:    converter.asm
#  Logic:
#           - Input number to convert
#           - Input base to conver to
#           - Convert number to desired base
#           - Prompt to try again
##################################################
.text
.globl main


#####################################################
main:

      li $s0, 2            #minimum base
      li $s1, 10           #maximum base

      jal getA             #input number
      jal getB             #input base
      jal convert          #convert number to base
      
      la $a0, endl
      li $v0, 4
      syscall

      la $a0, again
      li $v0, 4               #output "Would you like to try again"
      syscall
     
      la $a0, choice
      li $a1, 4               #input choice
      li $v0, 8
      syscall
      
      lb $s0, choice
      li $s1, 'y'             #choice = y - main
      beq $s0, $s1, main

      la $a0, ending
      li $v0, 4               #output "Ending.."
      syscall

      li $v0, 10              #end program
      syscall

######################################################

######################################################
#####input the number to convert######################
######################################################

getA:

      la $a0,msg1
      li $v0,4             #prompt for number
      syscall
      
      li $v0,5             #input number
      syscall
      
      blt $v0,$zero,getA   #number is negative, prompt again
      
      
      move $t0,$v0         #store input in t0
      
      jr $ra

######################################################


######################################################
######input base to convert to########################
######################################################

getB:

      la $a0,msg2
      li $v0,4             #prompt for base
      syscall
      
      li $v0,5             #input base
      syscall
      
      blt $v0,$s0,getB     #base < 2, prompt again
      bgt $v0,$s1,getB     #base > 10, prompt again
      
      move $t1,$v0         #store base in t1
      
      la $a0,msg3
      li $v0,4             #print "Result: "
      syscall
      
      move $a0,$t0         #number -> a0
      move $a1,$t1         #base -> a1
      
      jr $ra

######################################################


######################################################
#######convert number to base########################
######################################################

convert:
      #a0=A
      #a1=B

      #stack:
      #0 (ra)
      #4 (s1) number 
      #8 (s0) base
      #12(s3) counter

      addi $sp,$sp,-16     #push 4 words onto stack   
      
      sw $s3,12($sp)       #counter,used to know
                           #how many times we will pop from stack

      sw $s0,8($sp)        #A
      sw $s1,4($sp)        #B
      sw $ra,0($sp)         
      
      move $s0,$a0         #number -> s0
      move $s1,$a1         #base -> s1
      
      beqz $s0,end         #number = 0, end
      
      div $t4,$s0,$s1      #t4=A/B
      rem $t3,$s0,$s1      #t3=A%B

      add $sp,$sp,-4       #move the stack pointer
      sw $t3,0($sp)        #save t3(remainder)
      
      move $a0,$t4         #pass A/B
      move $a1,$s1         #pass B
      addi $s3,$s3,1

      jal convert        #call convert
      

 end:
      
      lw $ra,0($sp)     #pop the stack
      lw $s1,4($sp)
      lw $s0,8($sp)
      lw $s3,12($sp)

      beqz $s3,done
      lw $a0,16($sp)
      li $v0,1
      syscall

done: 
      addi $sp,$sp,20
      
      jr $ra   #return

######################################################


.data
msg1: .asciiz "Please insert value (positive numbers only) : "
msg2: .asciiz "Please insert the base value(2 to 10): "
msg3: .asciiz "\nResult : "
choice:.space 4
again:.asciiz "Would you like to try again(y,n)?"
endl: .asciiz "\n"
ending:.asciiz"Ending...:"
