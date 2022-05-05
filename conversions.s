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
.macro	print_int(%reg)
    	move $a0, %reg	# print_int(count)
    	li $v0, 1
    	syscall
.end_macro

            
main:
    	# $t1: count
	
    	li $a0, 1234	# count = percent_base_10(1234)
    	jal percent_base_10
    	move $t1, $v0 		
	
    	li $a0, '\n'	# print_char('\n')
    	li $v0, 11
    	syscall
	
    	move $a0, $t1	# print_int(count)
    	li $v0, 1
    	syscall
	
    	li $a0, 0 	    	# exit(0)
    	li $v0, 17
    	syscall


percent_base_10:  nop   	# percent_base_10(value)
			# prints the value in ASCII on stdout
    	# $v0: count
    	# $a0: value
    	# $t0: count
    	# $t1: value
    	# $t2: digit
    	# $t3: 10

	# Copy the values from the "a" registers
	move $t1, $a0	# print_int requires us to reuse the $a0 register
	li $t3, 10 		# place the immediate value in register

	li $t0, 0		## count = 0;
   top:	nop		## do {
    	divu $t1, $t3 	##
    	mfhi $t2		##   digit = value % base;
    	mflo $t1 		##   value = value / base;
    	print_int($t2)          ##   print_int(digit)
	addi $t0, $t0, 1	##   count++;

	bne $t1, $zero, top     ## } while (value != 0);

	move $v0, $t0	## return count
    	jr $ra
