# Snprintf Conversions Routines in MIPS assembly

This is a program assignment that will be updated throughout the next two weeks.

# Initial Tasks

1. Accept the assignment via the github classroom link provided during class
2. Create an initial repository
3. Copy the starter code (starter_code.mips) into conversions.mips
4. Commit/Push your initial version to your repo

# Version 1:

1. Write the percent_base_10 subroutine

```
# Task: Write a MIPS subroutine to convert a 32-bit unsigned number into a sequence of ASCII characters.  Each of these ASCII characters are printed to stdout in turn.
# The ASCII string created on stdout will be the corresponding (unsigned) decimal number, written in reverse.
# The subroutine returns the number of characters printed.
---
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
# Question:
#    - Should you use a while, for, or do-while loop?
#

# Sample Output
4321
4
```
2. Associated a tag called "version_1" with your completed implementation. (commit, push, etc.)
3. Push your code

# Version 2:
1. Modify your "percent_base_10"
   1. utilize the stack to save the individual digits
   2. at the end of the subroutine, print the individuals digits to stdout 
2. Associated a tag called "version_2" with your completed implementation

# Version 3:
1. Modify your code to:
   1. modify your "percent_base_10" subroutine
      1. to conform to the following declaration
         - int percent_base_10( &buffer, size, value)
      1. to replace the internal "print_int" syscall with placing the digits into the buffer
   2. modify the main subroutine
      1. to allocate a buffer of size 16 via syscall #9
      1. to call the percent_base_10 subroutine with following arguements
         - the address of the buffer
         - the size of the buffer
         - the value to be convert
      1. to print the buffer via the "print_string" system call
2. Associated a tag called "version_3" with your completed implementation
