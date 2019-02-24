pragma solidity ^0.5.0;

contract Tenant{
    
address public Tenant_Bank_address;// the payment address
address internal CoSigner_address;// the payment address
  
struct Car {
    string Make; 
    string Model;
    string Year;
    string Color;
    string PlateNumber;
}

    string Tenant_name;
    string CoSigner_Name;     
    string Phone_Number; 
    uint256 DateSigned;
    uint256 BedroomNumber;
    uint256 creditScore;
    Car myCar; 
    bool hasCar;
   
    constructor (address Tenant_Bank_Address , string memory tenant_name,
                    string memory phone_Number, uint256 bedroomNumber, uint256 creditscore) public {
 
                 Tenant_Bank_address = Tenant_Bank_Address ;
                 Tenant_name = tenant_name;    
                 CoSigner_Name = "Null";     
                 Phone_Number = phone_Number;  
                 DateSigned = now;
                 BedroomNumber = bedroomNumber;
                 creditScore = creditscore;
                 hasCar = false;
    }
    
    function addCar(string memory make, string memory  model, 
                    string memory year,string memory color,
                    string memory plateNumber)
                    public returns (bool){
                        
         myCar = Car(make,model,year,color,plateNumber);
         hasCar = true;
         return true; 
      
    }
    
    function add_CoSigner(address cosigner_address)
                    public returns (bool){
                        
        if (Tenant_Bank_address != CoSigner_address ) {             
                CoSigner_address = cosigner_address;
                return true;
        }
        else
            return false; 
        
    }
    
    function GetTenant_info() external view returns(string memory, string memory, uint256, bool){
        
        return (Tenant_name, Phone_Number, BedroomNumber, hasCar);
    }
    
    function getTenant_Address() external view returns(address){
        return Tenant_Bank_address;
    }
}
