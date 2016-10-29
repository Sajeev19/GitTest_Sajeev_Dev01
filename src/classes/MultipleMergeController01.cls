public with sharing class MultipleMergeController01 {

    public String objectToMerge { get; set; }
    
    public List<String> numericRules = new List<String> {'Keep highest value','Keep lowest value','Keep master value'};
    public List<String> dateRules = new List<String> {'Keep earliest value','Keep latest value','Keep master value'};
    public List<String> booleanRules = new List<String> {'Keep true value','Keep false value','Keep master value'};
    public List<String> multiPickListRules = new List<String> {'Keep all values','Keep no values','Keep master value'};
    public List<String> texttRules = new List<String> {'Keep longest value','Keep shortest value','Keep master value'};
    
    //************************
    // collection requires for merge
    //
    // valid merge fields of contact ...List<String> validContactMergeFields
    // map field name and data type map fieldNumber Map<String,String> fieldAndType
    // rule map     Map<String,String> fieldAndRuleMap
    //
    //*****************************
    
    List<String> validContactMergeFields;
    Map<String,String> contactFieldAndDataType;
    Map<String,String> fieldAndRuleMap ;
    
    
    public List<SelectOption> getItems(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Contact','Contact'));
        options.add(new SelectOption('Lead','Lead'));
        options.add(new SelectOption('Account','Account'));
        return options;
    }
    
    public MultipleMergeController01 () {
        
      
        getValidContactMergeFields();
        getContactFieldAndDataType ();
       
        getfieldAndRule();
        
    }
    
     public  List<String> getValidContactMergeFields() {
        validContactMergeFields = new List<String>();
        String fieldNames = '';
        Map<String,Schema.SObjectField> fieldMap = Schema.SObjectType.Contact.fields.getMap();
        Set<String> fieldSet = fieldMap.keySet();
        for(String fieldName : fieldSet){
           Schema.DescribeFieldResult field = (FieldMap.get(fieldName)).getDescribe();
                if (field.isUpdateable() && field.IsAccessible() && fieldName != 'Set_Number__c' && fieldName != 'Set_Master__c' && fieldName != 'Set_Processed__c')
                {
                     fieldNames +=field+', ';
                     validContactMergeFields.add(fieldName );
                }
        }
        if(fieldNames.endsWith(','))
            fieldNames  = fieldNames.substring(0,fieldNames.lastIndexOf(','));
        //return   fieldNames ; 
    
        return validContactMergeFields ;
    }
    
    

    private void getContactFieldAndDataType () {
        contactFieldAndDataType = new Map<String,String>();
        
        Map<String,Schema.SObjectField> fieldMap = Schema.SObjectType.Contact.fields.getMap();
        Set<String> fieldSet = fieldMap.keySet();
        for(String fieldName : fieldSet){
            String type  = getFieldType(fieldName );
            contactFieldAndDataType.put(fieldName ,type   );
            
        }
        //return contactFieldAndDataType ;
    }
  
    
    public static String getFieldType(String fieldName){
        // Assume that "sObjectName" is populated elsewhere
        //Schema.SObjectType t = Schema.getGlobalDescribe().get(sObjectName);
        String sObjectName = 'Contact';
        Schema.SObjectType t = Schema.getGlobalDescribe().get(sObjectName);
        Schema.DescribeSObjectResult r = t.getDescribe();
        Schema.DescribeFieldResult f = r.fields.getMap().get(fieldName).getDescribe();
        Schema.DisplayType dt = f.getType();
        
        String type = ' ';
        if (dt == Schema.DisplayType.String){
            type  = 'String';
        } else if ( dt == Schema.DisplayType.Integer || dt == Schema.DisplayType.Double || dt == Schema.DisplayType.Currency || dt == Schema.DisplayType.Percent) {
            type  = 'Integer';
        
        } else if (dt == Schema.DisplayType.Date || dt == Schema.DisplayType.DateTime) {
               type  = 'Date';    
        } else if (dt == Schema.DisplayType.Boolean) {
                type  = 'Boolean';      
        }
        else {
             type  = 'String';
        }
        return type;
    }
    
    
    private void getfieldAndRule  () {
    
        fieldAndRuleMap  =  new Map<String,String>();
        
        CCR_CLAM_2__CLAM__c clam;
        
       // string soql = 'select CCR_CLAM_2__Merge_Rules__c from CCR_CLAM_2__CLAM__c whereCCR_CLAM_2__Merge_Object__c = \'' + Contact + '\' ; //  \'' + setNo + '\' 
       // CCR_CLAM_2__CLAM__c[] config = (CCR_CLAM_2__CLAM__c[])Database.query(soql);
        
        List<CCR_CLAM_2__CLAM__c> config = [select CCR_CLAM_2__Merge_Rules__c from CCR_CLAM_2__CLAM__c where CCR_CLAM_2__Merge_Object__c = 'Contact' ];
        
        CCR_CLAM_2__CLAM__c c = config[0];
        string[] fieldAndrule = c.CCR_CLAM_2__Merge_Rules__c.split(';');
        for(integer i =0; i< fieldAndrule.size(); i++ ) {
            String f = fieldAndrule[i];
            system.debug(f);
             
             list<String> b = f.split(',');
             if(b.size() > 1) {
             
                 fieldAndRuleMap.put(b[0],b[1]);
             }
        }
        
        /*
        for(String e: fieldAndRuleMap.keySet()) {
            System.debug('keya' + e);
        }
       
         for(String d : fieldAndRuleMap.Values()) {
            System.debug('values' + d);
        }
        */
        //system.debug('key size ----->' + fieldAndRuleMap.keySet().size());
       // system.debug('valuesize------>' + fieldAndRuleMap.Values().size());
        
    }
     
//********************************************************  
public Component.Apex.PageBlockSection getContactPageBlockSection() {
    Component.Apex.PageBlockSection pbs = new Component.Apex.PageBlockSection();
        Map<String,Schema.SObjectField> FieldMap = Schema.SObjectType.Contact.fields.getMap();
        Set<String> FieldSet = FieldMap.keySet();
        List<String> FieldList = new List<string>();
        FieldList.addAll(FieldSet);
        FieldList.sort();
        
        for (String fieldName : FieldList) {
        
            Component.Apex.PageBlockSectionItem pbsi = new Component.Apex.PageBlockSectionItem();
             Schema.DescribeFieldResult field = (FieldMap.get(fieldName)).getDescribe();
             Component.Apex.SelectList selList = new Component.Apex.SelectList(id = field.getName(), multiselect = false, size = 1, style = 'width:200px;');
             string rule = '';
                
             if (field.isUpdateable() && field.IsAccessible() && fieldName != 'Set_Number__c' && fieldName != 'Set_Master__c' && fieldName != 'Set_Processed__c' && fieldName != 'IsPartner') {
                Schema.DisplayType dt = field.getType();
                Component.Apex.OutputLabel lblText = new Component.Apex.OutputLabel(escape = false);
                lblText.value = field.getLabel();
                pbsi.childComponents.add(lblText);
                if(dt == Schema.DisplayType.String) {
                     for(String option : texttRules ) {
                             Component.Apex.SelectOption selOption = new Component.Apex.SelectOption();
                             selOption.itemLabel = option;
                             selOption.itemValue = option;
                             selList.childComponents.add(selOption);
                     }                  
                 } else if (dt == Schema.DisplayType.Integer || dt == Schema.DisplayType.Double || dt == Schema.DisplayType.Currency || dt == Schema.DisplayType.Percent) {
                     for(String option : numericRules ) {
                             Component.Apex.SelectOption selOption = new Component.Apex.SelectOption();
                             selOption.itemLabel = option;
                             selOption.itemValue = option;
                             selList.childComponents.add(selOption);
                     }
                 } else if (dt == Schema.DisplayType.Date || dt == Schema.DisplayType.DateTime) {
                     for(String option : dateRules ) {
                             Component.Apex.SelectOption selOption = new Component.Apex.SelectOption();
                             selOption.itemLabel = option;
                             selOption.itemValue = option;
                             selList.childComponents.add(selOption);
                     }
                 } else if (dt == Schema.DisplayType.Boolean) {
                      for(String option : booleanRules ) {
                             Component.Apex.SelectOption selOption = new Component.Apex.SelectOption();
                             selOption.itemLabel = option;
                             selOption.itemValue = option;
                             selList.childComponents.add(selOption);
                      }
                 } else {
                     for(String option : texttRules ) {
                             Component.Apex.SelectOption selOption = new Component.Apex.SelectOption();
                             selOption.itemLabel = option;
                             selOption.itemValue = option;
                             selList.childComponents.add(selOption);
                     }   
                  }   
                  
                   pbsi.childComponents.add(selList);
                   pbs.childComponents.add(pbsi);
                
            } // end iof first if
        
        }  // end of for 
        
       return pbs;     


}// end of method

// ********************************************
   
    public List<String> getContactFileds() {
        Map<String,Schema.SObjectField> FieldMap = Schema.SObjectType.Contact.fields.getMap();
        Set<String> FieldSet = FieldMap.keySet();
        List<String> FieldList = new List<string>();
        FieldList.addAll(FieldSet);
        FieldList.sort();
        return FieldList;
        
     /*
      return only accessable and updatable fields
        for (string fieldName : FieldList)
        {
            Schema.DescribeFieldResult field = (FieldMap.get(fieldName)).getDescribe();
         
            if (field.isUpdateable() && field.IsAccessible() && fieldName != 'Set_Number__c' && fieldName != 'Set_Master__c' && fieldName != 'Set_Processed__c' && fieldName != 'IsPartner')
            {
        
            }
        }
        
      */
    
    }
    
    
    public Component.Apex.SelectList getRuleSelectList(String type) {
    
        Component.Apex.SelectList selList = new Component.Apex.SelectList(multiselect = false, size = 1, style = 'width:200px;');
        Component.Apex.SelectOption selOption;
        if(type == 'STRING'){
            for(String option : numericRules ) {
                 selOption = new Component.Apex.SelectOption();
                 selOption.itemLabel = option;
                 selOption.itemValue = option;
                 selList.childComponents.add(selOption);
            }
         }
        selList.childComponents.add(selOption);
        return selList;
        
    }
    /*
    public void MergeContacts1() {
    
    
        Map<String,Schema.SObjectField> fieldMap = Schema.SObjectType.Contact.fields.getMap();
         
        Set<String> fieldSet = fieldMap.keySet();
        
        String fieldList = '';
        List <String> validMergeFields = new List<String>();
         
        
        for(String fieldName : fieldSet ) {
            
            Schema.DescribeFieldResult field = fieldMap.get(fieldName).getDescribe();
            if (field.isUpdateable() && field.IsAccessible() && fieldName != 'Set_Number__c' && fieldName != 'Set_Master__c' && fieldName != 'Set_Processed__c')
                {
                    fieldList += fieldName + ', ';
                    validMergeFields.add(fieldName);
                }
        
        
        }
        
        System.debug('fieldList ----->' + fieldList );
        
        for(String field : validMergeFields ) {
            
            System.debug('----->' +field );
        
        }
    
    
    
    }
    */
    
    public void contactMerge1() {
    
        System.debug('-----contactMerge1------------');
        
        
       String fieldNames  = getContactFields(); 
        //String soql = 'select ' + fieldNames + ' from Contact where CCR_CLAM_2__Set_Number__c  = \'' + setNo + '\' order by CCR_CLAM_2__Set_Number__c  desc';
        String soql = 'select ' + fieldNames + ' from Contact where CCR_CLAM_2__Set_Number__c  = 1  order by CCR_CLAM_2__Set_Number__c  desc';
        
        system.debug('soql ----------------------------->' + soql );
        Contact[] duplicates = (Contact[])Database.query(soql);
        if(duplicates.size() > 1) {
            Contact master = duplicates [0];
            
            for(Integer i = 1 ; i < duplicates.size(); i++){
            
                Contact duplicate = duplicates[i];
                
                //for() loop through all valid contact merge fields
                // for eatch firld find out type
                //if(type = integer){
                    //find out rule for that type
                        // do integere merge
                //}
                
                
                     //List<String> validContactMergeFields;
                    //Map<String,String> contactFieldAndDataType;
                    //Map<String,String> fieldAndRuleMap ;
            
            }
            
        }
        
        //
            system.debug('----->' + validContactMergeFields.size());
                for(String f : validContactMergeFields) {
                    
                    System.debug('-------------->' + contactFieldAndDataType.get(f));
                    String type = contactFieldAndDataType.get(f);
                    if (type == 'Double' || type == 'Currency' || type == 'Percent') {
                     
                     
                     }
                    
                    
                 }
                  
            //
    
    }
    
 
    
    private String getContactFields() {
        String fieldNames = '';
        Map<String,Schema.SObjectField> fieldMap = Schema.SObjectType.Contact.fields.getMap();
        Set<String> fieldSet = fieldMap.keySet();
        
        for(String fieldName : fieldSet){
              Schema.DescribeFieldResult field = (FieldMap.get(fieldName)).getDescribe();    
              if (field.isUpdateable() && field.IsAccessible() && fieldName != 'Set_Number__c' && fieldName != 'Set_Master__c' && fieldName != 'Set_Processed__c')
              {
                     fieldNames +=fieldName +', ';
              }
        }
        SYSTEM.DEBUG('FIELD nAMES BEFORE SUBSTRING' +fieldNames  );
          fieldNames  = fieldNames  .substring(0, fieldNames.length() - 2);
         
         SYSTEM.DEBUG('FIELD nAMES AFTER SUBSTRING' +fieldNames  );
          
        
         /*
        if(fieldNames.endsWith(','))
            fieldNames  = fieldNames.substring(0,fieldNames.lastIndexOf(','));
            */
        return   fieldNames ; 
        
    }
    
  
    
     
    
    /*
    
    public void MergeContacts()
    {
        try
        {
            cInfo = 'Merging in progress - please wait...';
            string fieldList = '';
            List <String> validMergeFields = new List<String>();
            Map<string, Schema.SObjectField> FieldMap = Schema.SObjectType.Contact.fields.getMap();
            Set<string> FieldSet = FieldMap.keySet();
            
            for (string fieldName : FieldSet)
            {
                Schema.DescribeFieldResult field = (FieldMap.get(fieldName)).getDescribe();

                if (field.isUpdateable() && field.IsAccessible() && fieldName != 'Set_Number__c' && fieldName != 'Set_Master__c' && fieldName != 'Set_Processed__c')
                {
                    fieldList += fieldName + ', ';
                    validMergeFields.add(fieldName);
                }
            }
            
            fieldList = fieldList.substring(0, fieldList.length() - 2);
            string[] rules = hiddenField.split(';');
            hiddenField = '';
            
            if (cTotalSets > 0)
            {
                //Contact[] setObject = [select Set_Number__c from Contact where Set_Processed__c = false and Set_Number__c <> '' order by Set_Number__c asc limit 1];
                
                if (setObject.size() > 0)
                {
                    integer dupes = 0;
                    string setNo = setObject[0].Set_Number__c;
                    cSetNo = setNo;
                    string soql = 'select ' + fieldList + ' from Contact where Set_Number__c = \'' + setNo + '\' order by Set_Master__c desc';
                    Contact[] duplicates = (Contact[])Database.query(soql);
                    
                    if (duplicates.size() > 1)
                    {
                        Contact master = duplicates[0];
                        
                        for (integer i = 1; i < duplicates.size(); i++)
                        {
                            Contact duplicate = duplicates[i];
                            
                            for (string fieldName : validMergeFields)
                            {
                                Schema.DescribeFieldResult field = (FieldMap.get(fieldName)).getDescribe();
                                Schema.DisplayType dt = field.getType();
                                string rule = '';

                                for (integer j = 0; j < rules.size(); j++)
                                {
                                    if (rules[j].contains(field.getName()))
                                    {
                                        rule = rules[j].substring(rules[j].indexof(',') + 1);
                                        break;
                                    }
                                }
                                
                                string m = string.valueOf(master.get(fieldName));
                                string d = string.valueOf(duplicate.get(fieldname));
                                if (m == null || m == 'null') m = '';
                                if (d == null || d == 'null') d = '';
                                
                                if (dt == Schema.DisplayType.Double || dt == Schema.DisplayType.Currency || dt == Schema.DisplayType.Percent)
                                {
                                    if (m == '') m = '0';
                                    if (d == '') d = '0';

                                    if (rule == 'Keep highest value' && double.valueOf(d) > double.valueOf(m))
                                        master.put(fieldName, double.valueOf(d));
                                    else if (rule == 'Keep lowest value' && double.valueOf(d) < double.valueOf(m))
                                        master.put(fieldName, double.valueOf(d));
                                }
                                else if (dt == Schema.DisplayType.Date)
                                {
                                    if (rule != 'Keep master value' && d != '')
                                    {
                                        Date d1 = Date.valueof(d.substring(0, 10));
                                        
                                        if (m == '')
                                            master.put(fieldName, d1);
                                        else
                                        {
                                            Date m1 = Date.valueof(m.substring(0, 10));

                                            if (rule == 'Keep earliest value' && d1.daysBetween(m1) > 0)
                                                master.put(fieldName, d1);
                                            else if (rule == 'Keep latest value' && m1.daysBetween(d1) > 0)
                                                master.put(fieldName, d1);
                                        }
                                    }
                                }
                                else if (dt == Schema.DisplayType.DateTime)
                                {
                                    if (rule != 'Keep master value' && d != '')
                                    {
                                        Date d1 = Date.valueof(d.substring(0, 10));
                                        
                                        if (m == '')
                                            master.put(fieldName, DateTime.newInstance(d1.year(), d1.month(), d1.day()));
                                        else
                                        {
                                            Date m1 = Date.valueof(m.substring(0, 10));
                                            
                                            if (rule == 'Keep earliest value' && d1.daysBetween(m1) > 0)
                                                master.put(fieldName, DateTime.newInstance(d1.year(), d1.month(), d1.day()));
                                            else if (rule == 'Keep latest value' && m1.daysBetween(d1) > 0)
                                                master.put(fieldName, DateTime.newInstance(d1.year(), d1.month(), d1.day()));
                                        }
                                    }
                                }
                                else if (dt == Schema.DisplayType.Boolean)
                                {
                                    if (rule == 'Keep true value' && m == 'false' && d == 'true')
                                        master.put(fieldName, true);
                                    if (rule == 'Keep false value' && m == 'true' && d == 'false')
                                        master.put(fieldName, false);
                                }
                                else if (dt == Schema.DisplayType.MultiPicklist)
                                {
                                    if (rule == 'Keep all values')
                                    {
                                        string allValues = '';
                                        string masterMulti = m;
                                        string duplicateMulti = d;
                                        
                                        if (masterMulti == null || masterMulti == '')
                                            allValues = duplicateMulti;
                                        else if (duplicateMulti == null || duplicateMulti == '')
                                            allValues = masterMulti;
                                        else
                                        {
                                            string[] masterValues = masterMulti.split(';');
                                            string[] duplicateValues = duplicateMulti.split(';');
                                            
                                            for (integer j = 0; j < masterValues.size(); j++)
                                            {
                                                if (!allValues.Contains(masterValues[j].trim()))
                                                    allValues += masterValues[j] + ';';
                                            }
                                            
                                            for (integer k = 0; k < duplicateValues.size(); k++)
                                            {
                                                if (!allValues.Contains(duplicateValues[k].trim()))
                                                    allValues += duplicateValues[k] + ';';
                                            }
                                        }
                                        
                                        if (allValues != null && allValues.Length() > 0)
                                            master.put(fieldName, allValues);
                                    }
                                    else if (rule == 'Keep no values')
                                        master.put(fieldName, '');
                                }
                                else
                                {
                                    if (rule == 'Keep longest value' && d.length() > m.length())
                                        master.put(fieldName, d);
                                    else if (rule == 'Keep shortest value' && d.length() < m.length())
                                        master.put(fieldName, d);                                        
                                }
                            }
                            
                            duplicate.put('Set_Processed__c', true);
                            update duplicate;
                            master.put('Set_Processed__c', true);
                            dupes = duplicates.size() - 1;
                            Merge master duplicate;
                        }
                    }
                    else if (duplicates.size() == 1)
                        duplicates[0].put('Set_Processed__c', true);
                    
                    cObjectsMerged += dupes;
                    cSetsToProcess--;
                    cSetsProcessed++;

                    if (cSetsProcessed >= cTotalSets)
                    {
                        cInfo = 'Merging complete';
                        cSetsToProcess = 0;
                        cKeepMerging = false;
                    }
                    else
                        cKeepMerging = true;
                }
                else
                {
                    cInfo = 'Merging complete';
                    cSetsToProcess = 0;
                    cKeepMerging = false;
                }
            }
            else
            {
                cInfo = 'No sets to process';
                cSetsToProcess = 0;
                cKeepMerging = false;
            }
        }
        catch (Exception e)
        {
            cInfo = 'Error: ' + e;
            cKeepMerging = false;
        }
    }
    
    */  
    
}