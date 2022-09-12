# Week 11

## EVM Puzzle notes:

## Challenge 1:

`CALLVALUE`: The value of the current call in wei

`JUMP`: Alters the program counter, thus breaking the linear path of the execution (Pulls value from stack to point to appropriate `JUMPDEST`)

Solution: `8`

## Challenge 2:

`CODESIZE`: Each instruction is one byte. CODESIZE pushes the number of instructions to the stack

Solution:

The third instruction `SUB` will pop the first two values off the stack, and return the subtraction result, which `JUMP` will then pull. The `CODESIZE` is 10 and the `JUMPDEST` is 06. This means the `CALLVALUE` needs to be 4.

## Challenge 3:

`CALLDATASIZE`: Will push byte size of the calldata to the stack

Solution:

Enter call data of size 4(bytes), in hex `0xAAAAAAAA`

## Challenge 4:

`XOR`: Bitwise XOR operation will pop the first two values off the stack and push the result back on.

Solution:

The `CODESIZE` is 12 (0B) so we will input 6 (12 ^ 6 = 10)
See helpful link for calculating XOR results: https://xor.pw/#

## Challenge 5:

`DUP1` Reads the first item off the stack and pushes the same value onto the stack (first and second item on stack will be the same).

`EQ` Pops the first to items off the stack, pushes `1` back on if items are equal, other wise pushes `0`

`JUMPI` Pops two items off the stack. The first, the program counter to jump to (This must align with a JUMPDEST opcode) which will alter the linear execution path. The second, a boolean flag. The execution path will only change if the boolean flag is non-zero value, otherwise, execution will simply continue.

Solution:

Step through the instructions viewing the stack

### STEP 00
- Push input to stack (input is base10)

The Stack: |16|

### STEP 01
- Duplicate first item on stack

The Stack: |16|16|

### STEP 02
 - Multiply first two items on stack and push back result

The Stack: |256|

STEP 03
- Push `0100` onto the stack which is 256 in base10

### STEP 06
- Equality check. Pop off first two items and replace with 1, if equal or otherwise, 0.

The Stack: |1|

### STEP 07
- Push `0C` onto stack

The stack: |0C|1|

### STEP 09
- Pop first two items off stack. First, the location of the `JUMPDEST` if the second value is non zero.

The solution: `16`

## Challenge 6

`CALLDATALOAD`: This opcode will pop the first value off the call stack and use it as a byte offset for reading the call data. The result is pushed back onto the stack.

The solution: `0x000000000000000000000000000000000000000000000000000000000000000A`
`
## Challenge 7

`CALLDATACOPY`: Pops 3 items off stack & copies calldata to memory.
- destOffset: byte offset in the memory where the result will be copied
- offset: byte offset in the calldata to copy
- size: byte size to copy

`CREATE`: Pops 3 items off stack & pushes deployed contract address onto stack.
- value: value in wei to send to the new account.
- offset: byte offset in the memory in bytes, the initialisation code for the new account.
- size: byte size to copy (size of the initialisation code).


`EXTCODESIZE`: Pops contract address of stack and pushes code size of contract (bytes) back onto stack (Run time code only, this does not include what is written in the constructor).

Notes:

Using 'X' through here as variable, dependant on input

Step 03: |X|00|00|

Step 08: |X|00|00|

Step 0C: |X|01|

Step 0F: |X|13| <= Frist item ('X') must be non-zero value for `JUMPI`

Working backwards through the variables, we can see that the `EXTCODESIZE` must push a value of `01` onto the stack for this to succeed. 

Solution:

The following opcodes/bytecode essentially result in a single opcode contract that runs `STOP` (opcode number 00)
```
PUSH1 0x00
PUSH1 0x00
MSTORE
PUSH1 0x01
PUSH1 0x00
RETURN
```

`0x600060005260016000f3`

