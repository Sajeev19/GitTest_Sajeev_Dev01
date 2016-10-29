public class Dynamic_Apex_Controller {
/*
Added comment

*/

/*
Added comment2

*/

    public List<SelectOption> items { get;set; }
    public String selectedObj {get; set;}
    public List<Schema.SObjectField> fieldList {get; set;}
    public Boolean renderResult {get; set; }
    
    public Dynamic_Apex_Controller() {
        
        renderResult = false;
        List<Schema.SObjectType> objlst =  Schema.getGlobalDescribe().values();

        items = new List<SelectOption>();
        items.add(new SelectOption('','-----------------------None---------------------'));
        for(Schema.sobjectType objType : objlst ) {
            items.add(new SelectOption(String.valueOf(objType), String.valueOf(objType) ));   
        }
        items.sort();
    }
    
  public PageReference getFields(){
      fieldList  = new List<Schema.SObjectField>();
      if(selectedObj != null){
          Schema.SObjectType sType = Schema.GetGlobalDescribe().get(selectedObj );
           Schema.DescribeSobjectResult sTypeResult = sType.getDescribe();
           Map<String, Schema.SObjectField> m = sTypeResult.fields.getMap();
           for(Schema.SObjectField s1 : m.values()) {
               fieldList.add(s1);
               
           
           }
      }
      
      if(fieldList.isEmpty() != true) {
          renderResult = true;
          //fieldList.sort();
      }
    return null;
}

}