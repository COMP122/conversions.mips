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
    
# Add a macro to help out
.macro	print_string(%reg)
    	move $a0, %reg	# print_string(buffer)
    	li $v0, 8
    	syscall
.end_macro

            
main:
    	# $t7: count	# note that t1 is used by a subroutine
    	# $t8: &buffer	# pick two registers not used...

    	li $a0, 16
    	li $v0, 9 		# &buffer = malloc(16)
    	syscall
    	move $t8, $v0

	move $a0, $t8	# count = percent_base_10(&buffer, size, 1234)
	li $a1, 16
    	li $a2, 1234	
    	jal percent_base_10
    	move $t7, $v0 		
	
    	move $a0, $t8	# print_string(buffer)
    	li $v0, 4
    	syscall
	
    	li $a0, 0 	    	# exit(0)
    	li $v0, 17
    	syscall


percent_base_10:  nop   	# percent_base_10(&buffer, size, value)
			# prints the value in ASCII on stdout
    	# v0: count
    	# a0: &buffer
    	# a1: size
    	# a2: value
    	# t0: count
    	# t1: value
    	# t2: digit
    	# t3: 10
    	# t4: size
    	# s0: &buffer	# I did not want to re-adjust all my previous
    	# s1: size		# register allocation, so I just place the new
    	# s2: buff[count]	# variables in the "s" registers

	# Copy the values from the "a" registers
	move $s0, $a0
	move $s1, $a1
	move $t1, $a2	
	li $t3, 10 		# place the immediate value in register

	li $t0, 0		## count = 0;
   top1:	nop		## do {
    	divu $t1, $t3 	##
    	mfhi $t2		##   digit = value % base;
    	mflo $t1 		##   value = value / base;

			##   buffer[count] = digit2ascii(digit)
    	add $t2, $t2, '0'	     # digit = digit + '0' // transform it to ascii
    	add $s2, $s0, $t0            # location = buffer + count
    	sb $t2, 0($s2)          ##   # mem[location] = digit

	addi $t0, $t0, 1	##   count++;

	bne $t1, $zero, top1    ## } while (value != 0);

	move $v0, $t0	## return count;
    	jr $ra
