object "1155" {
    code {

        /* constructor (creation code)
        *  
        *  Assign owner to storage slot 0
        *  Deploy runstime code
        */

        sstore(0, caller())

        datacopy(0, dataoffset("runtime"), datasize("runtime"))
        return(0, dataszie("runtime"))
    }

    object "runtime" {
        code {
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

            default {
                revert(0,0)
            }

/*--------------Functions for Dispatcher-------------------------------------*/

            function balanceOf(account, id) -> v {
                revertIfZeroAddress(account)

                v := 
            }

            function balanceOfBatch(accounts, ids) -> balanceArr {

                /* note:
                *      The array args are pointers to memory slots, which show
                *      the length. Location of array args must be calculated.
                */

                addressArrLen := mload(acounts)
                idArrLen := mload(ids) 

                revertIfNotEqual(addressArrLen, idArrLen)

                balanceArr :=

                for { let i := 1 } lt() { i = add(i, 1) } {
                    val := _balanceOf( , )

                    //append val to correct array
                }

            }

            function setApprovalForAll(operator, approved) {
                revertIfEqual(operator, caller())
            }

            function isApprovedForAll(account, operator) -> isApproved {
                isApproved := false
            }
            
            /* Requires:
            *  - `to` cannot be zero address
            *  - if `caller` != `from`, check allowence
            *  - `from` must have appropriate balance
            *  - if `to` is a contract, check receiver 
            */
            function safeTransferFrom(from, to, id, amount, data) {
                revertIfZeroAddress(to)

                if iszero(eq(caller(), from)) {
                    if iszero(isApprovedForAll(from, caller())) {
                        revert(0, 0)
                    }
                }
                
                revertIfInsuficientBalance(from, id, amount)
                revertIfNonReceiverContract(to)

                _transfer()
                //pass appropriate args above
            }

            function safeBatchTransferFrom(from, to, ids, amounts, data) {

                /* note:
                *      The array args are pointers to memory slots, which show
                *      the length. Location of array args must be calculated.
                */

                idArrLen := mload(ids)
                amountArrLen := mload(amounts) 

                revertIfNotEqual(idArrLen, amountArrLen)
                
                for { let i := 1 } lt() { i = add(i, 1) } {
                    _transfer()
                    //pass appropriate args above
                    //increment counter
                }
            }
            
            function _transfer(from, to, id, amount) {
                revertIfZeroAddress(to)
            }

/*--------------Calldata decoding--------------------------------------------*/
            function selector() -> s {
                s := div(calldataload(0), 
                    0x10000000000000000000000000000000000000000000000) 
            }

            function decodeAsBytes(offset) -> {

            }

            function decodeAsAddress(offset) -> v {
                v := decodeAsUint(offset)
                if iszero(iszero(and(v, 
                    not(0xffffffffffffffffffffffffffffffffffffffff)))) {
                        revert(0, 0)
                }
            }

            function decodeAsAddressArr(offset) -> vArr {

            }

            function decodeAsUint(offset) -> v {
                let pos := add(4, mul(offset, 0x20))
                if lt(calldatasize(), add(pos, 0x20)) {
                    revert(0, 0)
                }
                v := calldataload(pos)
            }

            function decodeAsUintArr(offset) -> vArr {

            }
/*--------------Calldata encoding--------------------------------------------*/
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
            function revertIfZeroAddress(_address) {
                if iszero(_address) {
                    revert(0, 0)
                }
            }

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

            }


            function revertIfNonReceiverContract(to) {

            }
        }
    }
} 
