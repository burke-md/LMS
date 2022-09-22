# Bit shifting

While writting the ERC1155 contract in `yul` er are faced with an interesting
problem. At some point, we must parse the hash of a function sig from the 
calldata. 

There are two clear ways forward. The often seen division method and bit 
shifting

```
PUSH32 0x5c11d7950000...
PUSH1  0xe2
SHR
```

```
PUSH32 0x1ooo0000... (57 chars long)
PUSH32 0x5c11d795... (64 chars long)
DIV
```

It turns out that dividing a base 10 number by 10, effectively shifts the value
while dividing a hex value by 0x10 (that is 16 in base ten) also has a similiar
effect to shifting. 

See first the example for shifting method, second for division.
