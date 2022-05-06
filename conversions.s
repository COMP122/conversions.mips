# Name: percent_base_10
# File: conversion.s
# Declaration:  int percent_base_10( int value)
# Semantics:
#    - iteratively divides the input value by 10.
#    - converts the remainder to ASCII
#    - print outs the ASCII character to the stdout
#    - returns the number of ASCII characters printed
# Edge Condition:
#    - value = 0;


# Starter Code:
    .text
    .globl main
    
.macro  push(%reg)
        subi $sp, $sp, 4
        sw %reg, 0($sp)
.end_macro

.macro  pop(%reg)
        lw %reg, 0($sp)
        addi $sp, $sp, 4
.end_macro

            
main:
                # $t7: count            # note that t1 is used by a subroutine
                # $t8: &buffer          # pick two registers not used...
        
                li $a0, 16
                li $v0, 9               # &buffer = malloc(16)
                syscall
                move $t8, $v0
        
                move $a0, $t8           # count = percent_base_10(&buffer, size, 1234, 10)
                li $a1, 16
                li $a2, -1234   
                li $a3, 10 
                jal percent_signed_base
                move $t7, $v0           
                
                move $a0, $t8           # print_string(buffer)
                li $v0, 4
                syscall
                
                li $a0, 0               # exit(0)
                li $v0, 17
                syscall


percent_signed_base:                    # percent_signed_base(&buffer, size, value, base)
                # a0: buffer
                # a1: size
                # a2: value
                # a3: base
                # t1: char              # a real temp register

                # Since this routine is just a facade for unsigned base
                # Lets reuse the same "a" registers, i.e., don't bother to marshal
                blt $a2, $zero, neg_num
                bgt $a2, $zero, pos_num
                nop                     # value is zero
                b cont

      neg_num:  nop                     # if (value < 0) {
                li $t1, '-'             #    buffer[0] = '-';
                sw $t1, 0($a0)          
                addi $a0, $a0, 1        #    buffer++;
                subi $a1, $a1, 1        #    size --;
                nor $a2,$a2, $zero      #    value = (~value + 1);
                addi $a2, $a2, 1
                b cont

      pos_num:  nop                     # } elsif (value > 0) {
                li $t1, '+'             #    buffer[0] = '+';
                sw $t1, 0($a0)
                addi $a0, $a0, 1        #    buffer++;
                subi $a1, $a1, 1        #    size --;
                b cont
                       
      cont:     # opps!  makine a subroutine call
                # the $ra value is going to be overwritten
                push($ra)
                jal percent_unsigned_base
                pop($ra)
                # no need to remarshal return values
                jr $ra

        
percent_unsigned_base:  nop             # percent_unsigned_base(&buffer, size, value, base)
                # v0: count
                # a0: &buffer
                # a1: size
                # a2: value
                # a3: base
                # t0: count
                # t1: value
                # t2: digit
                # t3: base (10)         # the base was hard-coded but now a parameter
                # t4: size
                # t5: 9                 # The constant
                # s0: &buffer           # I did not want to re-adjust all my previous
                # s1: size              # register allocation, so I just place the new
                # s2: buff[count]       # variables in the "s" registers
        
                # Copy the values from the "a" registers
                move $s0, $a0
                move $s1, $a1
                move $t1, $a2 
                move $t3, $a3  
                li $t5, 9               # place the immediate value in register
        
                li $t0, 0               ## count = 0;

   top1:        nop                     ## do {
                divu $t1, $t3           ##
                mfhi $t2                ##   digit = value % base;
                mflo $t1                ##   value = value / base;
                push($t2)               ##   push($t2)
                addi $t0, $t0, 1        ##   count++;
        
                bne $t1, $zero, top1    ## } while (value != 0);
        
                move $t4, $t0           ## size = count;

                li $t0, 0               ## count = 0;
    top2:       nop                     ## do {
                pop($t2)                ##   pop(digit);

                                        ##   buffer[count] = digit2ascii(digit)
                ble $t2, $t5, digit0_9  #    if (digit <= 9) 
                b digitA_F
    digit0_9:   addi $t2, $t2, '0'      #        ascii_digit = digit + '0';
                b store

                                        #    if (digit > 9)
    digitA_F:   subi $t2, $t2, 10       #        ascii_digit = digit - 10 + 'A'; 
                addi $t2, $t2, 'A'
                b store

    store:      add $s2, $s0, $t0            # location = buffer + count
                sb $t2, 0($s2)          ##   # mem[location] = ascii_digit
  
                addi $t0, $t0, 1        ##   count++;
                subi $t4, $t4, 1        ##   size--;
        
                bgt $t4, $zero, top2    ## } while (size > 0 );

                                        ## buffer[count] = '\0'   //add the null char
                add $s2, $s0, $t0          # location = buffer + count
                sb $zero, 0($s2)           # mem[location] = 0
                move $v0, $t4           ## return count;
                jr $ra

