# Optimize and loop (with gas notes)

```
// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract Test {
uint256[] array = [1, 2, 3, 4];

    function iterate1() external view returns(uint256){
        // Gas 28644
        // Gas w/ optimizer 27754
        uint256 sum;

        for (uint256 i = 0; i < array.length; i++) {
            sum += array[1];
        }

        return sum;
    }

    function iterate2() external view returns(uint256){
        // Gas 28181
        // Gas w/ optimizer 27321
        uint256 sum;
        uint256 len = array.length;

        for (uint256 i = 0; i < len; i++) {
            sum += array[1];
        }

        return sum;
    }

    function iterate3() external view returns(uint256){
        // Gas 28195
        // Gas w/ optimizer 27343
        uint256 sum;
        uint256 len;
        assembly {
            len := sload(array.slot)
        }

        for (uint256 i = 0; i < len; i++) {
            sum += array[1];
        }

        return sum;
    }

    function iterate4() external view returns(uint256) {
        // Gas 28239
        // Gas w/ optimizer 27387
        uint256 sum;
        uint256 len;
        assembly {
            len := sload(0)
        }

        for (uint256 i = 0; i < len; i++) {
            sum += array[1];
        }

        return sum;
    }
}
```
