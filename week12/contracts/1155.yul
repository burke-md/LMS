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
                return(_balanceOf(decodeAsAddress(0), decodeAsUint(1))
            }

            // balanbceOfBatch(address[],uint256[])
            case 0x4e1273f4 {
                return(balanceOfBatch(decodeAsAddressArr(0), 
                    decodeAsUintArr(1))
            }

            // setApprovalForAll(address,bool)
            case 0xa22cb465 {

            }

            // isApprovedForAll(address,address)
            case 0xe985e9c5 {

            }

            // safeTransferFrom(address,address,uint256,uint256,bytes)
            case 0xf242432a {

            }

            // safeBatchTransferFrom(address,address,uint256[],uint256,bytes)
            case 0x2eb2c2d6 {

            }

            default {
                revert(0,0)
            }

/*--------------Functions for Dispatcher-------------------------------------*/
            function _balanceOf(account, id) -> {

            }

            function balanceOfBatch(addressArr, idArr) -> balanceArr {
                //Define array to be appended to

                for { let i := 1 } lt() {i = add(i, 1) } {
                    val := _balanceOf( , )

                    //append val to correct array
                }

            }

/*--------------Calldata decoding--------------------------------------------*/
            function selector() -> s {

            }

            function decodeAsAddress(offset) -> v {

            }

            function decodeAsAddressArr(offset) -> vArr {

            }

            function decodeAsUint(offset) -> v {

            }

            function decodeAsUintArr(offset) -> vArr {

            }
/*--------------Calldata encoding--------------------------------------------*/
/*--------------Events-------------------------------------------------------*/
            function emitTransferSingle(operator, from, to, id, value) {
        
            }

            function emitTransferBatch(operator, from, to, ids, values) {

            }

            function emitApprovalForAll(account, operator, approved) {

            }

            function emitURI(value, id) {

            }

            function emitEvent(signatureHash, indexed1, indexed2, nonIndexed) {

            }
/*--------------Storage layout-----------------------------------------------*/
/*--------------Storage access-----------------------------------------------*/
/*--------------Utility functions--------------------------------------------*/
        }
    }
} 
