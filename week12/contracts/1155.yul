object "1155" {
    code {

    }
    object "runtime" {
        code {
/*--------------Protect against sending Ether--------------------------------*/
            require(iszero(calleValue()))
/*--------------Dispatcher---------------------------------------------------*/
            switch selector()
            // balanceOf(account, id)
            case 0x17f87bf7 { 

            }
            // balanbceOfBatch(accounts,ids)
            case 0x0dce3006 {

            }
            // setApprovalForAll(operator, approved)
            case 0xc578b524 {

            }
            // isApprovedForAll(account, operator)
            case 0x62554e03 {

            }
            // safeTransferFrom(from, to, id, amount, data)
            case 0xd2f28423 {

            }
            // safeBatchTransferFrom(from, to, ids, amounts, data)
            case 0x5376c70b {

            }
            default {
                revert(0,0)
            }

/*--------------Functions for Dispatcher-------------------------------------*/
/*--------------Calldata decoding--------------------------------------------*/
/*--------------Calldata encoding--------------------------------------------*/
/*--------------Events-------------------------------------------------------*/
/*--------------Storage layout-----------------------------------------------*/
/*--------------Storage access-----------------------------------------------*/
/*--------------Utility functions--------------------------------------------*/
        }
    }
} 
