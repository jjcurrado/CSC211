##################################################
#
#  Name:       John Currado
#  Program:    IOSortArray
#
#
#  Logic:      - Input numbers -> array
#              - Output the array
#              - Sort array (smallest -> largest)
#              - Output the array
#              - Prompt to continue
#                 - if yes, start again
#                 - if no, exit program
#
#
##################################################


   .text
   .globl main

main:
      
      jal input
      jal output
      jal sort
      jal output
      jal EOP 





############input subprogram##############

input:
      
      la $a0, numbers
      li $v0, 4               #print "Enter how many numbers? : "
      syscall

      li $v0, 5               #input count
      syscall

      sw $v0, count           #store into data

      la $t1, array           #load array to t1
      lw $t0, count           #load count to t0

in_loop:

      beqz $t0, end_in_loop   #theres no items to input


      li $v0, 5               #input number
      syscall

      sw $v0, ($t1)           #store into array

      addi $t0, $t0, -1       #decrement count
      addi $t1, $t1, 4        #go to next array element 

      j in_loop 
       
end_in_loop:

      la $a0, endl
      li $v0, 4               #print end of line
      syscall

      jr $ra                 #return to call location

      
###########end input subprogram#########



###########sort subprogram##############

sort:
      la $a0, sorting
      li $v0, 4
      syscall

      la $t1, array           #array address -> t1
      lw $t0, count           #count -> t0

      addi $t0, $t0, -1       #index of the last element -> t0

      blez $t0, end_sort      #there one or less elements - dont sort

      mul $t0, $t0, 4         #address offset of last element->t0

      li $t4, 0               #address offset of a[i]
      li $t5, 4               #address offset of a[j]
      
      
search:

      add $t2, $t1, $t4       #address of a[i] -> $t2
      add $t3, $t1, $t5       #address of a[j] -> $t3
      lw $t6, ($t2)           #a[i] -> $t6
      lw $t7, ($t3)           #a[j] -> $t7

      ble $t7, $t6, swap      #a[j] < a[i] - swap them

      addi $t5, $t5, 4        #increment offset of a[j]
      bgt $t5, $t0, shift     #j offset > last element offset - shift
     
      j search
       
swap:
    
      lw $t6, ($t2)           #a[i] -> $t6
      lw $t7, ($t3)           #a[j] -> $t7
      sw $t6, ($t3)           #$t6 -> a[j] 
      sw $t7, ($t2)           #$t7 -> a[i]                       
      addi $t5, $t5, 4        #increment a[j] offset
      bgt $t5, $t0, shift     #j offset > last element offset - shift
      j search

shift:

      addi $t4, $t4, 4         #increment i offset
      beq $t4, $t0, end_sort   #i offset is at last element - end
      addi $t5, $t4, 4         #j offset = i + 4
      j search

end_sort:
      
      jr $ra


############end sort subprogram############



##########output subprogram#############

output:
      
      lw $t0, count           #count -> $t0
      la $t1, array           #array address -> $t1

out_loop:

      beqz $t0, end_out_loop  #count = 0 - end

      lw $a0, ($t1)           #current element -> $a0
      li $v0, 1               #print current element
      syscall

      la $a0, space           #print space
      li $v0, 4
      syscall

      addi $t0, $t0, -1       #decrement count
      addi $t1, $t1, 4        #increment array address
      j out_loop 

end_out_loop:
      jr $ra

############end output##################


############EOP subprogram##############
EOP:

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

#######end of EOP subprogram############

   .data

choice:.space     4
array:.space      400
count:.word       0

space:.asciiz     "    "

endl:.asciiz      "\n"

numbers:.asciiz   "How many numbers would you like to input? :  "
ending:.asciiz    "\n\n\nEnding Program..."
sorting:.asciiz   "\n\n\nSorting...\n\n\n"
again:.asciiz     "\n\nWould you like to try again(y,n)? : "



##################################################
#
#  Output:
#
#     How many numbers would you like to input? :  4
#     1
#     -3
#     40
#     8
#   
#   1    -3    40    8    
#   
#   
#   Sorting...
#   
#   
#   -3    1    8    40    
#   
#   Would you like to try again(y,n)? : y
#   How many numbers would you like to input? :  2
#   23
#   -10
#   
#   23    -10    
#    
#   
#   Sorting...
#   
#   
#   -10    23    
#   
#   Would you like to try again(y,n)? : y
#   How many numbers would you like to input? :  10
#   -233
#   436
#   436
#   89
#   -16
#   -83
#   44
#   99
#   22
#   46
#   
#   -233    436    436    89    -16    -83    44    99    22    46    
#   
#   
#   Sorting...
#   
#   
#   -233    -83    -16    22    44    46    89    99    436    436    
#   
#   Would you like to try again(y,n)? : n
#   
#   
#   
#   Ending Program...
#   
##################################################
