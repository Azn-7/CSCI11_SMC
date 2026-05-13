# CSCI11_SMC

**(For CSCI11 Computer Architecture class)** A simple math calculator that can perform postfix calculation using the LC3 assembly language. Created as my final project for CSCI11, it is programmed to handle postfix calculation that is within 16-bits, meaning calculations that cannot exceed under -32,768 or over 32,767.

Currently, the program isn't fully complete with no UI implementation and is missing one critical feature (i.e. outputting a multi-digit value).

## Installation
- Install [LC3 Tools](https://github.com/chiragsakhuja/lc3tools) found on Github
- After installing, open SMC.asm within the program.
- Run in the simulator

## Keys Guide

- **0-9** - Numeric values
- **\+** - Addition operator
- **\-** - Subtration operator
- **\*** - Multiplication operator
- **\/** - Divison operator
- **\.** - Echo the result found on top of stack
- **ENTER KEY** - Outputs a new line for cleaner expression
- **SPACE KEY** - Finish a multi-digit value

## Calculator Prompts

The calculator will prompt either 4 symbols. Please keep it in mind while using it. Any error prompts will automatically restart the program to ensure stability.

- **\>** = (Ready for input)
  - The program is ready to accept a new input
- **\?** = (Input error)
  - **Applicable cases:** Inputing a key that isn't found in the Keys Guide above.
- **\$** = (Stack error)
  - **Applicable cases:** Size of stack is too small to perform operation (<1)
- **\!** = (Numeric error)
  - **Applicable cases:** Overflow/Underflow calculations.
  - The program can only handle 16-bit calculations, so results must be between (-32,768 <-> 32,767)

## How to use

- The program will expect a math expression in postfix notation (also known as reverse polish notation)
- When prompted for input ('>'), enter a postfix math expression as normal.
  - This also implies that the calculator can take multi-digit inputs, but will immediately push onto stack if the input is a 4-digit input or greater.
  - Furthermore, should an expression ever lead to an out-of-range of 16-bits, even if the final result isn't, an error will be thrown.
- You may only input keys found in the Keys Guide above. Everything else will be ignored and will not echo it.
- When entering a number, the calculator will automatically presume you are entering a muli-digit value until you input an operator sign, space (" "), or type a 4th digit.
  - Note: You can only type a max of 4 digits for a single value.
  - Ex. Typing "423" will push the decimal value 423 onto the stack. However, typing "42 3" will push the decimal value 42 and then value 3 onto the stack.
- Proceed as you would when typing in postfix calculation, and when you want to see the current value, type "." or the period key to output the current result (top of stack).
  - Note: It outputs the top of stack, meaning if the expression isn't fully complete, any numbers that isn't fully calculated yet will not be outputted. 
- Be careful when using the calculator! The program calculates on the spot whenever inputting a value or operator, so treat every input as if its being calculated for every new input. This means that should an expression ever lead to an error, the program will automatically throw an error and restart the program.