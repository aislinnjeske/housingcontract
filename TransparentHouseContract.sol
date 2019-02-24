pragma solidity ^0.5.0;
import "./Tenant.sol";
import "./WorkOrder.sol";

contract TransparentHouseContract{
    
address internal landlord;
address internal Property_Owner;

struct Property_Address {
    string Street_Address; 
    string City;
    string State;
    string Country;
    uint256 Zipcode; 
}

    Property_Address property_address; 
    uint256 DateBuilt;// Unix Timestamp
    uint256 Rent_DueDate;
    uint256 NumberofTentants; 
    uint256 MAXNumberofTentants; 
    Tenant[] Current_Tenents;
    uint8 Rental_State;// 0=VACANT , 1=FILLED
    uint256 rent;
    WorkOrder[] propertyWorkOrders;
  
    modifier only_owner(){
        require(msg.sender == landlord);
        _;
    }
}

contract property is TransparentHouseContract{
    
   //Setting up the contract 
    constructor (uint256 Rent, string memory StreetAddress,string memory city, string memory state,string memory county, uint256 zipcode, uint maxNum) public {
           landlord = msg.sender;
           property_address = Property_Address(StreetAddress,city, state,county, zipcode);
           DateBuilt= now;
           Rental_State=0;
           NumberofTentants = 0;
           MAXNumberofTentants= maxNum;
           rent = Rent;
          // Rent_DueDate = updateRentDue(); 
    }
    
    
    
    function addTenant(string memory tenant_name, string memory phone_Number, uint256 creditScore) public returns(bool){
       if(MAXNumberofTentants != NumberofTentants+1){
                Rental_State=1;
                Tenant t= new Tenant(msg.sender, tenant_name, phone_Number, NumberofTentants+1, creditScore);
                Current_Tenents.push(t);
                NumberofTentants += 1;
                //Map_of_Tenant_Address[msg.sender]= t;
                return true; 
       }
       else {
            return false;
          
       }
       
    }
  
    function addCartoTenant(string memory make, string memory model, string memory year,string memory color,string memory plateNumber) 
                    public payable returns (bool){
                    
            for(uint256 i = 0; i < NumberofTentants; i++){
                if(Current_Tenents[i].getTenant_Address() == msg.sender){
                    return Current_Tenents[i].addCar(make, model, year, color, plateNumber);
                }
            }
            return false;
    }
    
    function addCoSignertoTenant(address Cosignor_Address) public returns (bool){
        for(uint256 i = 0; i < NumberofTentants; i++){
                if(Current_Tenents[i].getTenant_Address() == msg.sender){
                    return Current_Tenents[i].add_CoSigner(Cosignor_Address);
                }
            }
            return false;
    }
    
    
    //View Functions
    function Property_Details() external view returns(string memory,string memory,string memory,string memory,uint256 ){
        return (property_address.Street_Address, property_address.City,property_address.State,property_address.Country,property_address.Zipcode);
    }
    
    function GetNumTenants() external view returns(uint){
      return Current_Tenents.length;
       // return NumberofTentants;
    }
    
    function GetStatus() external view returns(string memory){
        if (Rental_State == 1){
            return "Filled";
        }
        else{
            return "Vacant";
        }
    }
    
    // function GetTenantInfo() external view returns (strings){
    //     for(uint256 i = 0; i < NumberofTentants; i++){
    //             Current_Tenents[i].GetTenant_info()
    // }
    
     function GetRentCost() external view returns(uint){
         return rent;
  
     }
     
     
    // Paying and Withdrawal functionS
    function payRent() public payable {
        require(msg.value >= rent, "Minimum transfer must be equal to the rent");
    }
    
    function Withdrawal() public only_owner returns(bool) {
        msg.sender.transfer(address(this).balance);
        return true; 
    }

    function contractBalance() public view returns(uint){
         return address(this).balance;
    }
    
    //Work Order Functions
    function placeWorkOrder(uint256 category, string memory reason) public returns(uint256){
        WorkOrder wo = new WorkOrder(category, reason);
        propertyWorkOrders.push(wo);
        wo.submitWorkOrder();
        return wo.getSerialNumber();
    }
    
    function resolveWorkOrder(uint256 serialNumber) only_owner public {
        for(uint256 i = 0; i < propertyWorkOrders.length; i++){
            WorkOrder wo = propertyWorkOrders[i];
            if(wo.getSerialNumber() == serialNumber){
                wo.resolveWorkOrder();
            }
        }
    }
    
    function getStatusOfWorkOrder(uint256 serialNumber) public view returns(bool){
        for(uint256 i = 0; i < propertyWorkOrders.length; i++){
            WorkOrder wo = propertyWorkOrders[i];
            if(wo.getSerialNumber() == serialNumber){
                return wo.getStatus();
            }
        }
    }
    
//House Status Functions 
    // 
        
    
    
    
    

    
    
}
