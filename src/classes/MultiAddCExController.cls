public class MultiAddCExController {

/*
Added comment

*/
//http://kemissalesforceworld.wordpress.com/2012/12/29/managing-multiple-records-at-a-time-via-visualforce/


    List <Campaign_Expense__c> CExList;
    public Id cID = ApexPages.currentPage().getParameters().get('Id'); //grab the Campaign ID
    public Id getID {get; set;}
    
    public PageReference reset()  { //pull at most 8 expense records to show so we don't clutter up the page
        CExList = [select name, Campaign__c, Item__c, Cost__c, Date_of_Expense__c from Campaign_Expense__c where Campaign__c =: cID order by createddate limit 8 ];
        return null; //stay on the vf page
    }
   
    public List <Campaign_Expense__c> getCExs() {
       if(CExList == null) reset();
       return CExList;
   }
    
    public void setAccounts(List <Campaign_Expense__c> cexs) {
       CExList = cexs;
    }
    
    public PageReference save() {//upsert records on save
        upsert CExList;
        ApexPages.Message myMsg = new ApexPages.message(ApexPages.Severity.Info, 'Records Saved Successfully'); //show confirmation message on save
        ApexPages.addMessage(myMsg);
        return null;
    }
    public PageReference add() {
        CExList.add(New Campaign_Expense__c(Campaign__c = cID)); //add records to Campaign Expense and associate with current Campaign
        return null; 
    }

}