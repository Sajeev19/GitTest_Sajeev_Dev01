public with sharing class RemotingObjects3Controller {

   //Variables  
    public String accountName { get; set; }  
    public static Account account { get; set; }  
      
    // constructor  
    public RemotingObjects3Controller () { }    
      
    //Remote Action  
    @RemoteAction  
    public static Account getAccount(String accountName) {  
        account = [SELECT Id, Name, Phone, Type, NumberOfEmployees FROM Account WHERE Name = :accountName];  
        return account;  
    }  
    
    
}