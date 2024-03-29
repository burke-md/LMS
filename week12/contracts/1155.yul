object "1155" {
    code {

        /* constructor (creation code)
        *  
        *  Assign owner to storage slot 0
        *  Push uri string length into slot
        *  Push uri string (encoded) to storage
        *  Deploy runstime code
        */

        sstore(0, caller())

        // URI string = https://example/{id}.json length 25(0x19) bytes
        sstore(3, 0x19) 
        sstore(4, 0x68747470733a2f2f6578616d706c652f7b69647d2e6a736f6e) 

        datacopy(0, dataoffset("runtime"), datasize("runtime"))
        return(0, dataszie("runtime"))
    }

    object "runtime" {
        code {

            // Create free memory pointer
            mstore(0x40, 0x60)

            function ownerPos() -> p { p := 0 }

            function balancePos() -> p { p := 1 }

            function approvalPos() -> p { p := 2 }
            
            function uriLenPos() -> p { p := 3 }

/*--------------Protect against sending Ether--------------------------------*/

            require(iszero(calleValue()))

/*--------------Dispatcher---------------------------------------------------*/

            switch selector()

            // balanceOf(address,uint256)
            case 0x00fdd58e { 
                return(balanceOf(decodeAsAddress(0), decodeAsUint(1))
            }

            // balanbceOfBatch(address[],uint256[])
            case 0x4e1273f4 {
                return(balanceOfBatch(decodeAsAddressArr(0), 
                    decodeAsUintArr(1))
            }

            // setApprovalForAll(address,bool)
            case 0xa22cb465 {
                setApprovalForAll(decodeAsAddress(0), decodeAsBool(1)
            }

            // isApprovedForAll(address,address)
            case 0xe985e9c5 {
                return(isApprovedForAll(decodceAsAddress(0), decodeAsAddress(1))
            }

            // safeTransferFrom(address,address,uint256,uint256,bytes)
            case 0xf242432a {
                safeTransferFrom(
                    decodeAsAddress(0),
                    decodeAsAddress(1),
                    decodeAsUint(2),
                    decodeAsUint(3),
                    decodeAsBytes(4)
                )
            }

            // safeBatchTransferFrom(address,address,uint256[],uint256,bytes)
            case 0x2eb2c2d6 {
                safeBatchTransferFrom(
                   decodeAsAddress(0),
                   decodeAsAddress(1),
                   decodeAsUintArr(2),
                   decodeAsUintArr(3),
                   decodeAsBytes(4)
                ) 
            }

            // uri(uint256)
            case 0x0E89341C {
                getUri()
            }

            // mint(address,uint256,uint256,bytes)
            case 0x731133E9 {
                mint(decodeAsAddress(0), decodeAsUint(1), decodeAsUint(2), decodeAsBytes(3))
            }

            // mintBatch(address,uint256[],uint256[],bytes)
            case 0x1F7FDFFA {
                mintBatch(
                    decodeAsAddress(0),
                    decodeAsUintArr(1),
                    decodeAsUintArr(2),
                    decodeAsBytes(3)
                )
            }

            // burn(address, uint256,uint256)
            case 0xF5298ACA {
                burn(decodeAsAddress(0), decodeAsUint(1), decodeAsUint(2))
            }

            // burnBatch(address,uint256[],uint256[])
                burnBatch(decodeAsAddress(0), decodeAsUintArr(1), decodeAsUintArr(2))
            }

            default {
                revert(0,0)
            }

/*--------------Functions for Dispatcher-------------------------------------*/
            
            /* Requires:
            *  'account' cannot be the zero address
            */
            function balanceOf(account, id) -> v {
               /* Requirment to revert if zero address
               *  is handled by 'decodeAsAddress' masking op
               */

                let balancePointer := getBalancePointer(account, id)
                v := sload(balancePointer)
            }
            
            /* Requires:
            *  - 'accounts' and 'ids' must have same length
            */
            function balanceOfBatch(accounts, ids) -> balanceArrayPointer {

                /* Note:
                *  The array args are pointers to memory slots, which show
                *  the length. Location of array args must be calculated.
                */

                let addressArrLen := mload(acounts)
                let idArrLen := mload(ids) 

                revertIfNotEqual(addressArrLen, idArrLen)

                /* Note:
                *  Get pointer to next free memory
                *  Iterate through array of address
                *  Locate account/id in memory based on `i` of iteration
                *  Grab account balance
                *  Store balance in sequential memory 'push to array'
                *  Return pointer to 'array'
                */

                let freeMemPointer := mload(0x40)

                let _balanceArrayPointer := freeMemPointer

                // Store first item in array (length of array)
                pushToMem(_balanceArrayPointer, addressArrLen)

                for { let i := 1 } lt(i, add(addressArrLen, 1)) { i := add(i, 1) } {

                    /* Where `accounts` is the pointer to the begining of the 
                    *  accounts array, move forward in memory `i` x 32-byte 
                    *  blocks. 32 base ten == 0x20
                    */
                    let account := mload(add(accounts, mul(i, 0x20)))
                    let id := mload(add(ids, mul(i, 0x20)))

                    let accountBalance := balanecOf(account, id)

                    pushToMem(mload(0x00), accountBalance)

                }
                balanceArrayPointer := _balanceArrayPointer
            }

            /* Requirements:
            *  - `operator` cannot be the caller
            */
            function setApprovalForAll(operator, approved) {
                revertIfEqual(operator, caller())

                let approvalPointer := getOperatorApprovalPointer(
                    caller(), operator)
                
                sstore(approvalPointer, approved)

                emitApprovedForAllEvent(caller(), operator, approved)
            }

            function isApprovedForAll(account, operator) -> isApproved {
                let approvalPointer := getOperatorApprovalPointer(
                    account, operator)
                isApproved := sload(approvalPointer)
            }
            
            /* Requires:
            *  - `to` cannot be zero address
            *  - if `caller` != `from`, check allowence
            *  - `from` must have appropriate balance(basic implementation will 
            *     not check balance, rather bool value. All or nothing.
            *  - if `to` is a contract, check receiver 
            */
            function safeTransferFrom(from, to, id, amount, data) {
               /* Requirment to revert if zero address
               *  is handled by 'decodeAsAddress' masking op
               */

                if iszero(eq(caller(), from)) {
                    if iszero(isApprovedForAll(from, caller())) {
                        revert(0, 0)
                    }
                }
                
                revertIfInsuficientBalance(from, id, amount)

                _transfer(from, to, id, amount)
                
                // Handle receiver for 'to' as contract
                let extSize := extcodesize(to)
                if gt(extSize, 0) {
                    callERC1155Received(from, to, id, amount, data)
                }

                emitTransferSingle(caller(), from, to, id, amount)
            }

            /* Requirements:
            *  - `ids` and `amounts` must have same length
            *  - `to` must not be zero address
            *  - if `to` is a contract, check receiver 
            */  
            function safeBatchTransferFrom(from, to, ids, amounts, data) {

               /* Requirment to revert if zero address
               *  is handled by 'decodeAsAddress' masking op
               */

                /* Note:
                *  The array args are pointers to memory slots, which show
                *  the length. Location of array args must be calculated.
                */
                let idArrLen := mload(ids)
                let amountArrLen := mload(amounts) 

                revertIfNotEqual(idArrLen, amountArrLen)

                for { let i := 1 } lt(i, add(idArrLen, 1)) { i := add(i, 1) } {
                    
                    // Get info at correct index i
                    let id := mload(add(ids, mul(0x20, i)))
                    let amount := mload(add(amounts, mul(0x20, i)))

                    revertIfInsuficientBalance(from, id, amount)
                    _transfer(from, to, id, amount)
                }
                
                // Handle receiver for 'to' as contract
                let extSize := extcodesize(to)
                if gt(extSize, 0) {
                    callERC1155BatchReceived(from, to, ids, amounts, data)
                }

                emitTransferBatch(caller(), from, to, ids, amounts)
            }

            /* Internal function called as helper
            *  All requirments to be handled before calling
            */
            function _transfer(from, to, id, amount) {

                let fromBalancePointer := getBalancePointer(from, id)
                let fromBalanceValue := sload(fromBalancePointer)
                sstore(fromBalancePointer, sub(fromBalanceValue, amount))

                let toBalancePointer := getBalancePointer(to, id)
                let toBalanceValue := sload(toBalancePointer)
                sstore(toBalancePointer, add(toBalanceValue, amount))
            }
            
            /*
            *
            */
            function getUri() {
                let uriLen := sload(uriLenPos())

                let freeMemPointer := mload(0x40)

                // Push uri string offset
                mstore(freeMemPointer, 0x20)

                // Push uri string length
                mstore(add(freeMemPointer, 0x20), uriLen)

                // Push string 
                for (let := i } lt(i, add(2, div(uriLen, 0x20))) { i := add(i, 1) }
                {
                    // Handle multi slot length uri strings
                    let slot := add(uriLen, i)
                    let data := sload(slot)

                    mstore(add(mul(i, 0x20), add(freeMemPointer, 0x40), data)
                }
                // string offset, data
                return(0x00, add(mul(uriLen, 0x20), freeMemPointer)))
            }


            function mint(to, id, amount, data) {
                _mint(to, id, amount)

                emitTransferSingle(caller(), 0x00, to, id, amount)
            }

                
            function mintBatch(to, ids, amounts, data) {
                let idArrLen := mload(ids)
                let amountArrLen := mload(amounts)

                revertIfNotEqual(idArrLen, amountArrLen)

                for { let i := 1 } lt(i, add(idArrLen, 1) {i := add(i, 1) {
                {
                    let id := mload(add(ids, mul(i, 0x20))
                    let amount := mload(add(amounts, mul(i, 0x20)))

                    _mint(to, id, amount)
                }

                emitTransferBatch(
                    caller(),
                    0x00,
                    to,
                    ids,
                    amounts
                )
            }


            /*
            * Internal helper
            * Will revert if minting to zero address (decodeAsAddress masking op)
            */
            function _mint(to, id, amount) {
                let accountBalanceKey := getBalancePointer(to, id)
                let balance := sload(accountBalanceKey)

                sstore(accountBalanceKey, add(balance, amount))
            }

            function burn(from, id, amount) {
                _burn(from, id, amount)

                emitTransferSingle(caller(), from, 0x00, id, amount)
            }

            function burnBatch(from, ids, amounts) {
                let idArrLen := mload(ids)
                let amountArrLen := mload(amounts)

                revertIfNotEqual(idArrLen, amountArrLen)

                for { let i := 1 } lt(i, add(idArrLen, 1)) { i := add(i, 1) } 
                { 
                    let id := mload(add(
                    let amount := mload(add(ids, mul(i, 0x20)))

                    _burn(from, id, amount)
            }

            /*
            * Internal helper
            * Will revert if burning from zero address (decodeAsAddress masking op)
            */
            function _burn(from, id, amount) {
                let accountBalanceKey := getBalancePointer(from, id) 
                let balance := sload(accountBalanceKey)

                revertIfInsuficientBalance(from, id, amount)

                sstore(accountBalanceKey, sub(balance, amount))
            }
/*--------------Calldata decoding--------------------------------------------*/
            function selector() -> s {
                s := shr(calldataload(0), 0xE2)
            }

            function decodeAsBytes(offset) {
                // First four bytes are for function selector

                let calldataPointer := add(4, mul(0x20, offset)
                let arg := calldataload(calldataPointer)
                let lenPointer := add(4, arg)
                let len := calldataload(lenPointer)

                let freeMemPointer :=  mload(0x40)
                pushToMem(freeMemPointer, len) 

                // Get number of slots required
                let slots := add(div(len, 0x20), 1)
                
                // Copy appropriate calldata to mem
                calldatacopy(add(freeMemPointer, 0x20), 
                    add(lenPointer, 0x20), slots)


                // Incremenet free memory pointer
                pushToMem(0x40, add(0x20, slots))
                
            }

            function decodeAsAddress(offset) -> v {
                v := decodeAsUint(offset)
                if iszero(iszero(and(v, 
                    not(0xffffffffffffffffffffffffffffffffffffffff)))) {
                        revert(0, 0)
                }
            }

            function decodeAsAddressArr(offset) -> vArr {
                vArr := decodeAsArray(offset)
            }

            function decodeAsUint(offset) -> v {
                let pos := add(4, mul(offset, 0x20))
                if lt(calldatasize(), add(pos, 0x20)) {
                    revert(0, 0)
                }
                v := calldataload(pos)
            }

            function decodeAsUintArr(offset) -> vArr {
                vArr := decodeAsArray(offset)
            }

            /* Internal function called as helper
            *  All requirments to be handled before calling
            */
            function _decodeAsArray(offset) -> arrayPointer {
                // Get arg from call data
                let argPointer := add(4, mul(0x20, offset))
                let arg := calldataload(argPointer)
                let lenPointer := add(4, arg)
                let len := calldataload(lenPointer)

                // Store length of array in memory at first avail slot
                let freeMemPointer := mload(0x40)
                mstore(freeMemPointer, len)

                // Copy array from calldata into memory after len
                    calldatacopy(add(freeMemPointer, 0x20), add(lenPointer, 0x20),
                        mul(len, 0x20))
                // Increment freee memory pointer
                    pushToMem(0x40, add(0x20, len)

            }
/*--------------Events-------------------------------------------------------*/
            function emitTransferSingle(operator, from, to, id, value) {
                let signatureHash := 0xc3d58168c5ae7397731d063d5bbf3d657854427343f4c083240f7aacaa2d0f62

                mstore(0x00, id)
                mstore(0x20, value)

                log4(0x00, 0x40, signatureHash, operator, from, to)
            }

            function emitTransferBatch(operator, from, to, ids, values) {
                let signatureHash := 0x4a39dc06d4c0dbc64b70af90fd698a233a518aa5d07e595d983b8c0526c8f7fb
                
                // log4(offset,size,topic1,topic2,topic3,topic4)
                log4(0x00, x, signatureHash, operator, from, to)
            }

            function emitApprovalForAll(account, operator, approved) {
                let signatureHash := 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31
                
                mstore(0x00, approved) 

                log3(0x00, 0x20, signatureHash, owner, operator)
            }


            function emitURI(value, id) {
                let signatureHash := 0x6bb7ff708619ba0610cba295a58592e0451dee2622938c8755667688daf3529b

                // log2(offset,size,topic1,topic2)
                log2(0x00, x, signatureHash, id)
            }

/*--------------Utils--------------------------------------------------------*/

            function revertIfNotEqual(arg1, arg2) {
                if iszero(eq(arg1, arg2)) {
                    revert(0, 0)
                }
            }

            function revertIfEqual(arg1, arg2) {
                if eq(arg1, arg2) {
                    revert(0, 0)
                }
            }

            function revertIfInsuficientBalance(from, id, amount) {
                let balance := sload(getBalancePointer(from, id)

                if gt(amount, balance) {
                    revert(0, 0)
                }
            }

            function hashTwo(arg1, arg2) -> h {
                // Store two args in memory, hash and return value
                let freeMemPointer := mload 0x40

                pushToMem(freeMemPointer, arg1)
                pushToMem(add(freeMemPointer, 0x20), arg2)

                pushToMem(add(freeMemPointer, 0x40), keccak256(freeMemPointer,
                    add(freeMemPointer,0x20)

                h := mload(add(freeMemPointer, 0x40))
            }

            /* This function will push a 32byte piece of data
            *  to memory and then increment the free memory pointer
            */
            function pushToMem(location, data) {
                mstore(location, data)
                mstore(0x40, add(location, 0x20)
            }

            function callERC1155BatchReceived(from, to, ids, amounts, data) {
                let freeMemPointer := mload(0x40)
                let selector := shl(0xE0, 0xBC197C81)
                let idsLen := mload(ids)
                let dataLen := mload(data)

                //Push selector
                mstore(freeMemPointer, selector)

                // Push operator (free memory is now 4 bytes further)
                mstore(add(freeMemPointer, 0x04), caller())

                // Push from 
                mstore(add(freeMemPointer, 0x24), from)

                // Push ids offset
                mstore(add(freeMemPointer, 0x44), 0xA0)

                // Push amounts offset
                let valuesArrOffset := add(add(0xa0, 0x20), mul(ids, 0x20))
                mstore(add(freeMemPointer, 0x64), valuesArrOffset)

                // Push data offset 
                let dataArrOffset := add(add(valuesArrOffset, 0x20), mul(idsLen, 0x20))
                mstore(add(freeMemPointer, 0x84), dataArrOffset)

                // Push ids length 
                let idsArrLenPointer := add(freeMemPointer, 0xA4)
                mstore(idsArrLenPointer, idsLen)

                // Store ids in mem

                if idsLen {
                    for { let i := 1 } lt(i, add(1, idsLen)) { i := add(i, 1) }
                    {
                        let _data := mload(add(idsArrLenPointer, mul(i, 0x20)))
                        mstore(add(add(freeMemPointer, 0xA4), mul(i, 0x20)), _data)
                    }
                }    

                let amountsArrLenPointer := add(add(ids, 0x20), mul(idsLen, 0x20))
                mstore(amountsArrLenPointer, idsLen)
                
                // Store amounts in mem

                if idsLen {
                    for { let i := 1 } lt(i, add(1, idsLen)) { i := add(i, 1) }
                    {
                        let _data := mload(add(amountsArrLenPointer, mul(i, 0x20)))
                        mstore(add(add(freeMemPointer, 0xA4), mul(i, 0x20)), _data)
                    }
                }    

                // Store data in mem

                let dataArrLenPointer := add(add(amountsArrLenPointer, 0x20), mull(idsLen, 0x20)), 0x20)
                mstore(dataArrLenPointer, add(1, div(dataLen, 0x20))

                if dataLen {
                    for { let i := 1 } lt(i, add(2, div(dataLen, 0x20))) { i := add(i, 1) }
                    {
                        let _data := mload(add(data, mul(i, 0x20)))
                        mstore(add(dataLen, mul(i, 0x20)), _data)
                    }
                }    

                let success := call(
                    gas(),
                    to,
                    0,
                    freeMemPointer,
                    add(
                        add(0xA4, mul(2, add(0x20, mul(idsArrLenPointer, 0x20)))),
                        add(0x40, mul(0x20, div(dataLen, 0x20)))
                    ),
                    freeMemPointer,
                    0x20
                )

                if iszero(success) {
                    revert(0,0)
                }

                let res := mload(freeMemPointer)

                if iszero(eq(res, selector)) {
                    revert(0,0)
                }
            }
            
            function callERC1155BReceived(from, to, id, amounts, data) {
                let freeMemPointer := mload(0x40)
                //inputPointer := 
                let selector := shl(0xE0, 0xf23a6e61)
                let dataLen := mload(data)

                //Push selector
                mstore(freeMemPointer, selector)

                // Push operator (free memory is now 4 bytes further)
                mstore(add(freeMemPointer, 0x04), caller())

                // Push from 
                mstore(add(freeMemPointer, 0x24), from)

                // Push id 
                mstore(add(freeMemPointer, 0x44), id)

                // Push amount
                mstore(add(freeMemPointer, 0x64), amount)

                // Push data offset 
                mstore(add(freeMemPointer, 0x84), 0xA0)

                // Push data length
                mstore(add(freeMemPointer, 0xA4), add(div(dataLen, 0x20), 1))

                // Push data (if exists)

                if dataLen {
                    for { let i := 1 } lt(i, add(2, div(dataLen, 0x20))) { i := add(i, 1) }
                    {
                        let _data := mload(add(data, mul(i, 0x20)))
                        mstore(add(add(freeMemPointer, 0xA4), mul(i, 0x20)), _data)
                    }
                }

                // Make call

                let success := call(
                    gas(),
                    to,
                    0,
                    freeMemPointer,
                    add(0xc4, mul(dataLen, 0x20)),
                    mload(0x40),
                    0x20
                )

                if iszero(success) {
                    revert(0,0)
                }

                let res := mload(mload(0x40))

                if iszero(eq(res, selector)) {
                    revert(0,0)
                }
            }
/*--------------Getters------------------------------------------------------*/
            function getBalancePointer(account, id) p -> {
                /* balance = mapping(uint256 id => mapping(address account =>
                *     uint256 balance))
                *
                *  keccak256(account, kecak256(id, balanceSlot))
                */

                p := hashTwo(account, hachTwo(id, balancePos()))

            }

            function getOperatorApprovalPointer(account, operator) -> p {
                /* mapping(account => mapping(operator => approved))
                *
                */keccak256(operator, (keccak256(account, approvalSlot))

                p := hashTwo(operator, hashTwo(account, approvalPos()))
            }
        }
    }
} 
