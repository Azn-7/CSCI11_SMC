# CSCI11_SMC

(For CSCI11 Computer Architecture class) A simple math calculator that can perform postfix calculation using the LC3 assembly language.

## Keys Guide

- **0-9** - Numeric values
- **\+** - Addition operator
- **\-** - Subtration operator
- **\*** - Multiplication operator
- **\/** - Divison operator
- **\.** - Echo the result found on top of stack
- **\#** - Call for multi-digit input
  - By default, the calculator accepts primary single digit values. You can input a multi-digit value by inputting '#' first, then type up to 4 digits
  - Example: 55\*#5000/

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
- When prompted for input ('>'), enter a numeric value and press ENTER to add the value onto stack
  - This also implies that the calculator can take multi-digit inputs, but will immediately push onto stack if the input is a 6-digit input or greater.
  - Furthermore, should the input be out-of-range of 16-bit, an error will be thrown.
