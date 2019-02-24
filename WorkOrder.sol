pragma solidity ^0.5.0;
contract WorkOrder {
    
    enum Category {
        PLUMBING,
        YARD,
        ELECTRIC,
        REPLACEMENT,
        INTERNET,
        OTHER
    }
    
    Category category;
    string reason;
    uint256 serialNumber;
    bool resolved = false;
    bool submitted = false;
    
    constructor(uint256 WorkOrder_Category, string memory Reason) public {
        if(WorkOrder_Category == 1){
            category = Category.PLUMBING;
        } else if(WorkOrder_Category == 2){
            category = Category.YARD;
        } else if(WorkOrder_Category == 3){
            category = Category.ELECTRIC;
        } else if(WorkOrder_Category == 4){
            category = Category.REPLACEMENT;
        } else if(WorkOrder_Category == 5){
            category = Category.INTERNET;
        } else {
            category = Category.OTHER;
        }
        
        reason = Reason;
        serialNumber = now;
    }
    
    function submitWorkOrder() public {
        submitted = true;
    }
    
    function resolveWorkOrder() public {
        resolved = true;
    }
    
    function getSerialNumber() external view returns(uint256){
        return serialNumber;
    }
    
    function getStatus() external view returns(bool){
        return resolved;
    }
    
}
