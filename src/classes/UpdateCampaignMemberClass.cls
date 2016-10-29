public with sharing class UpdateCampaignMemberClass {
    
    public final CampaignMember cm;

    private ApexPages.StandardController cmController;


    public UpdateCampaignMemberClass(ApexPages.StandardController controller) {
        
        cmController = controller;
        this.cm = (CampaignMember)controller.getRecord();

    }
    
    
     public PageReference UpdateAction() {
        try{
                update cm;
            }
            catch(DmlException ex){
                ApexPages.addMessages(ex);
            }
       
        return new PageReference('http://jdk470.force.com/?id=' + cm.id );
        
    }
      
    public string getStatus(string Status){
            return 'Status';
    } 
}