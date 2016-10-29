public with sharing class MultipleMerge001Controller {

        public String selectedObjectName { get; set;}
            
        public Boolean renderRule {get; set; }
        
        public Boolean renderTitle {get; set;}
        
        public Boolean rebderButtons {get; set;}
        
        public String headerTitle { get; set;}
        
        public String headerSubtitle { get; set; }
        
        public List<String> numericRules = new List<String> {'Keep highest value','Keep lowest value','Keep master value'};
        public List<String> dateRules = new List<String> {'Keep earliest value','Keep latest value','Keep master value'};
        public List<String> booleanRules = new List<String> {'Keep true value','Keep false value','Keep master value'};
        public List<String> multiPickListRules = new List<String> {'Keep all values','Keep no values','Keep master value'};
        public List<String> texttRules = new List<String> {'Keep longest value','Keep shortest value','Keep master value'};
        
      
    
    Map<String, List<String>> colorCodes =    new Map<String, List<String>>();
    //colorCodes.put('Red', numericRules );
    //colorCodes.put('Blue', '0000A0');
    
    
        public MultipleMerge001Controller() {
                
                //loadObjectNames();
                setIntialValues();
                setObjectName();
                
        }
        
        public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','<----SelectObject ---->'));
            options.add(new SelectOption('Contact','Contact'));
            options.add(new SelectOption('Lead','Lead'));
            options.add(new SelectOption('Account','Account'));
            return options;
        }
       
        
        private void setObjectName() {
        
                if(selectedObjectName == 'Contact') {
                        
                        headerTitle = 'Contact';
                }
                else if (selectedObjectName == 'Lead') {
                        
                        headerTitle = 'Lead';
                        
                }
                else if (selectedObjectName == 'Account') {
                        
                        headerTitle = 'Account';
                        
                }
        }
        
        private void setIntialValues() {
        
            renderRule  = false;
            renderTitle  = false;
            rebderButtons  = false;
            
        
        }
        
        public PageReference showButtons(){
            system.debug('inside show buttons');
          rebderButtons  = true;
            return null;
        }
        
        public PageReference selectRules() {
        
              renderRule = true;
            return null;
        }
    
     public PageReference showResult() {
        
       renderTitle = true;
        return null;
     }
     
     // create a page block with all fields of a selected  object
     // get all the fields of the selected object.
     // create a field name - data type map
    //loop through the field names ....get data type...get corresponding rule...render field name and select box with rule.
     
     
     //
    
    //create a method that return select list form a list of values.use this method every time by passing a list of rules. 
    
    
/*
    	Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Opportunity.fields.getMap();

Map<String,String> fieldNameAndType = new Map<String,String>();

for(String  fieldName : fieldMap.keySet() ) {   
 Schema.DescribeFieldResult field = (FieldMap.get(fieldName)).getDescribe();
 Schema.DisplayType dt = field.getType();
 System.debug('---------dt>' + dt);
    
fieldNameAndType.put(fieldName, String.valueOf(dt));
}

for ( String filedName: fieldNameAndType.keySet()) {
    System.debug( filedName + '->' + fieldNameAndType.get(filedName));
    
}

    
*/
    
    //************************
    
    // merge
    
}