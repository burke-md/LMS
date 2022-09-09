# Week 11

## EVM Puzzle notes:

### Challenge 1:

`CALLVALUE`: The value of the current call in wei

`JUMP`: Alters the program counter, thus breaking the linear path of the execution (Pulls value from stack to point to appropriate `JUMPDEST`)

Solution: `8`

### Challenge 2:

`CODESIZE`: Each instruction is one byte. CODESIZE pushes the number of instructions to the stack

Solution:

The third instruction `SUB` will pop the first two values off the stack, and return the subtraction result, which `JUMP` will then pull. The `CODESIZE` is 10 and the `JUMPDEST` is 06. This means the `CALLVALUE` needs to be 4.

### Challenge 3:

`CALLDATASIZE`: Will push byte size of the calldata to the stack

Solution:

Enter call data of size 4(bytes), in hex `0xAAAAAAAA`



