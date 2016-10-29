public with sharing class MultipleMergeController2
{

    public String accountPageBlockSection { get; set; }

    public String leadPageBlockSection { get; set; }

    public String contactPageBlockSection { get; set; }

    public String aStringSetNo { get; set; }

    public String lStringSetNo { get; set; }

    public String cStringSetNo { get; set; }

    public PageReference SaveAccountMergeRules() {
        return null;
    }


    public PageReference MergeAccounts() {
        return null;
    }


    public PageReference SaveLeadMergeRules() {
        return null;
    }


    public PageReference MergeLeads() {
        return null;
    }


    public PageReference SaveContactMergeRules() {
        return null;
    }


    public PageReference MergeContacts() {
        return null;
    }

    public integer cTotalSets { get; set; }
    public integer cSetsToProcess { get; set; }
    public integer cSetsProcessed { get; set; }
    public integer cObjectsMerged { get; set; }
    public string cSetNo { get; set; }
    public string cInfo { get; set; }
    public integer cMasters { get; set; }
    public integer lTotalSets { get; set; }
    public integer lSetsToProcess { get; set; }
    public integer lSetsProcessed { get; set; }
    public integer lObjectsMerged { get; set; }
    public string lSetNo { get; set; }
    public string lInfo { get; set; }
    public integer lMasters { get; set; }
    public integer aTotalSets { get; set; }
    public integer aSetsToProcess { get; set; }
    public integer aSetsProcessed { get; set; }
    public integer aObjectsMerged { get; set; }
    public string aSetNo { get; set; }
    public string aInfo { get; set; }
    public integer aMasters { get; set; }
    public string hiddenField{ get; set; }
    public boolean cKeepMerging { get; set; }
    public boolean lKeepMerging { get; set; }
    public boolean aKeepMerging { get; set; }
    
    public MultipleMergeController2()
    {
        //GetSetCounts();
        cSetsProcessed = 0;
        cObjectsMerged = 0;
        cSetNo = '';
        cMasters = 0;
        lSetsProcessed = 0;
        lObjectsMerged = 0;
        lSetNo = '';
        lMasters = 0;
        aSetsProcessed = 0;
        aObjectsMerged = 0;
        aSetNo = '';
        aMasters = 0;
        cKeepMerging = false;
        lKeepMerging = false;
        aKeepMerging = false;
    }
   
   
}


/*

 public void GetSetCounts()
    {
        try
        {
   
            AggregateResult[] cResult = [select count_distinct(Set_Number__c) from contact where Set_Number__c <> '' and Set_Processed__c = false];
            cSetsToProcess = integer.valueOf(cResult[0].get('expr0'));
            cTotalSets = cSetsToProcess;
            
            cResult = [select count_distinct(Set_Number__c) from contact where Set_Master__c = true and Set_Processed__c = false];
            cMasters = integer.valueOf(cResult[0].get('expr0'));
        
            AggregateResult[] lResult = [select count_distinct(Set_Number__c) from lead where Set_Number__c <> '' and Set_Processed__c = false];
            lSetsToProcess = integer.valueOf(lResult[0].get('expr0'));
            lTotalSets = lSetsToProcess;

            lResult = [select count_distinct(Set_Number__c) from lead where Set_Master__c = true and Set_Processed__c = false];
            lMasters = integer.valueOf(lResult[0].get('expr0'));
                    
            AggregateResult[] aResult = [select count_distinct(Set_Number__c) from account where Set_Number__c <> '' and Set_Processed__c = false];
            aSetsToProcess = integer.valueOf(aResult[0].get('expr0'));
            aTotalSets = aSetsToProcess;
            
            aResult = [select count_distinct(Set_Number__c) from contact where Set_Master__c = true and Set_Processed__c = false];
            aMasters = integer.valueOf(aResult[0].get('expr0'));
            
        }
        catch (Exception e)
        {
            cInfo = 'Error getting set counts: ' + e;
        }
    }
    
    public Component.Apex.PageBlockSection getContactPageBlockSection()
    {
        return GetFields('Contact');
    }
    
    public Component.Apex.PageBlockSection getLeadPageBlockSection()
    {
        return GetFields('Lead');    
    }
    
    public Component.Apex.PageBlockSection getAccountPageBlockSection()
    {
        return GetFields('Account');
    }
    
    public Component.Apex.PageBlockSection GetFields(string objectName)
    {
        Map<string, Schema.SObjectField> FieldMap;
        
        if (objectName == 'Contact')
            FieldMap = Schema.SObjectType.Contact.fields.getMap();
        else if (objectName == 'Lead')
            FieldMap = Schema.SObjectType.Lead.fields.getMap();
        else if (objectName == 'Account')
            FieldMap = Schema.SObjectType.Account.fields.getMap();
          
        Set<string> FieldSet = FieldMap.keySet();
        List<string> FieldList = new List<string>();
        FieldList.addAll(FieldSet);
        FieldList.sort();
        Component.Apex.PageBlockSection pbs = new Component.Apex.PageBlockSection(columns = 2);
        string soql = 'select Merge_Rules__c from CLAM__c where Merge_Object__c = \'' + objectName + '\'';
       // CLAM__c[] config = (CLAM__c[])Database.query(soql);        
        string[] rules;

        if (config != null && config.size() > 0)
        {
            if (config[0].Merge_Rules__c != null)
            {
                string allRules = config[0].Merge_Rules__c;
                rules = allRules.split(';');
            }
        }

        for (string fieldName : FieldList)
        {
            Component.Apex.PageBlockSectionItem pbsi = new Component.Apex.PageBlockSectionItem();
            Schema.DescribeFieldResult field = (FieldMap.get(fieldName)).getDescribe();
         
            if (field.isUpdateable() && field.IsAccessible() && fieldName != 'Set_Number__c' && fieldName != 'Set_Master__c' && fieldName != 'Set_Processed__c' && fieldName != 'IsPartner')
            {
                Schema.DisplayType dt = field.getType();
                Component.Apex.OutputLabel lblText = new Component.Apex.OutputLabel(escape = false);
                lblText.value = field.getLabel();
                pbsi.childComponents.add(lblText);

                Component.Apex.SelectList selList = new Component.Apex.SelectList(id = field.getName(), multiselect = false, size = 1, style = 'width:200px;');
                string rule = '';
                
                if (rules != null)
                {
                    for (integer j = 0; j < rules.size(); j++)
                    {
                        if (rules[j].contains(field.getName()))
                        {
                            rule = rules[j].substring(rules[j].indexof(',') + 1);
                            break;
                        }
                    }
                }
                
                if (rule != '')
                    AddSelectOption(selList, rule);
                
                if (dt == Schema.DisplayType.Integer || dt == Schema.DisplayType.Double || dt == Schema.DisplayType.Currency || dt == Schema.DisplayType.Percent)
                {
                    if (rule != 'Keep highest value')
                        AddSelectOption(selList, 'Keep highest value');
                    
                    if (rule != 'Keep lowest value')
                        AddSelectOption(selList, 'Keep lowest value');
                    
                    if (rule != 'Keep master value')
                        AddSelectOption(selList, 'Keep master value');
                }
                else if (dt == Schema.DisplayType.Date || dt == Schema.DisplayType.DateTime)
                {
                    if (rule != 'Keep earliest value')
                        AddSelectOption(selList, 'Keep earliest value');
                    
                    if (rule != 'Keep latest value')
                        AddSelectOption(selList, 'Keep latest value');
                    
                    if (rule != 'Keep master value')
                        AddSelectOption(selList, 'Keep master value');   
                }
                else if (dt == Schema.DisplayType.Boolean)
                {
                    if (rule != 'Keep true value')
                        AddSelectOption(selList, 'Keep true value');
                    
                    if (rule != 'Keep false value')
                        AddSelectOption(selList, 'Keep false value');
                    
                    if (rule != 'Keep master value')
                        AddSelectOption(selList, 'Keep master value');
                }
                else if (dt == Schema.DisplayType.MultiPickList)
                {
                    if (rule != 'Keep all values')
                        AddSelectOption(selList, 'Keep all values');
                    
                    if (rule != 'Keep no values')
                        AddSelectOption(selList, 'Keep no values');
                    
                    if (rule != 'Keep master value')
                        AddSelectOption(selList, 'Keep master value');
                }
                else
                {
                    if (rule != 'Keep longest value')
                        AddSelectOption(selList, 'Keep longest value');
                    
                    if (rule != 'Keep shortest value')
                        AddSelectOption(selList, 'Keep shortest value');
                    
                    if (rule != 'Keep master value')
                        AddSelectOption(selList, 'Keep master value');
                }
                
                pbsi.childComponents.add(selList);
                pbs.childComponents.add(pbsi);
            }
        }

        return pbs;
    }
    
    public void AddSelectOption(Component.Apex.SelectList selList, string option)
    {
         Component.Apex.SelectOption selOption = new Component.Apex.SelectOption();
         selOption.itemLabel = option;
         selOption.itemValue = option;
         selList.childComponents.add(selOption);
    }
   
    public void SaveContactMergeRules()
    {
        SaveMergeRules('Contact');
    }
    
    public void SaveLeadMergeRules()
    {
        SaveMergeRules('Lead');
    }
    
    public void SaveAccountMergeRules()
    {
        SaveMergeRules('Account');
    }
    
    public void SaveMergeRules(string mergeObject)
    {

        CLAM__c clam;
        string soql = 'select Merge_Rules__c from CLAM__c where Merge_Object__c = \'' + mergeObject + '\'';
        CLAM__c[] config = (CLAM__c[])Database.query(soql);
        
        if (config == null || config.size() == 0)
        {
            clam = new CLAM__c();
            clam.Name = mergeObject + ' merge rules';
            clam.Merge_Object__c = mergeObject;
            insert clam;
            soql = 'select Merge_Rules__c from CLAM__c where Merge_Object__c = \'' + mergeObject + '\'';
            config = (CLAM__c[])Database.query(soql);
        }
        
        if (config != null)
        {
            clam = config[0];
            clam.Merge_Rules__c = hiddenField;
            hiddenField = '';
            update clam;
            
            if (mergeObject == 'Contact')
                cInfo = 'Merge rules saved';
            else if (mergeObject == 'Lead')
                lInfo = 'Merge rules saved';
            else if (mergeObject == 'Account')
                aInfo = 'Merge rules saved';
        }
        
    }

    public void FlagCMasters()
    {
        FlagMasterRecords('Contact');
    }
    
    public void FlagLMasters()
    {
        FlagMasterRecords('Lead');
    }
    
    public void FlagAMasters()
    {
        FlagMasterRecords('Account');
    }
    
    public void FlagMasterRecords(string mergeObject)
    {
        Contact master;
        integer setNo = 0;
        string criteria;
        
        if (criteria == 'Earliest record')
        {
            string soql = 'select id, set_master__c from contact where set_number__c = \'' + setNo + '\' order by createddate asc limit 1';
            master = (Contact)Database.query(soql);
        }
        else if (criteria == 'Latest record')
        {
            string soql = 'select id, set_master__c from contact where set_number__c = \'' + setNo + '\' order by createddate desc limit 1';
            master = (Contact)Database.query(soql);
        }
        else if (criteria == 'Most related campaigns')
        {
            
        }
    }
    
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
    
    public void MergeLeads()
    {
        try
        {
            lInfo = 'Merging in progress - please wait...';
            string fieldList = '';
            List <String> validMergeFields = new List<String>();
            Map<string, Schema.SObjectField> FieldMap = Schema.SObjectType.Lead.fields.getMap();
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
            
            if (lTotalSets > 0)
            {
                //Lead[] setObject = [select Set_Number__c from Lead where Set_Processed__c = false and Set_Number__c <> '' order by Set_Number__c asc limit 1];
                
                if (setObject.size() > 0)
                {
                    integer dupes = 0;
                    string setNo = string.valueOf(setObject[0].Set_Number__c);
                    lSetNo = setNo;
                    string soql = 'select ' + fieldList + ' from Lead where Set_Number__c = \'' + setNo + '\' order by Set_Master__c desc';
                    Lead[] duplicates = (Lead[])Database.query(soql);
                    
                    if (duplicates.size() > 1)
                    {
                        Lead master = duplicates[0];
                        
                        for (integer i = 1; i < duplicates.size(); i++)
                        {
                            Lead duplicate = duplicates[i];
                            
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
                                        
                                if (dt == Schema.DisplayType.Integer)
                                {
                                    if (m == '') m = '0';
                                    if (d == '') d = '0';

                                    if (rule == 'Keep highest value' && integer.valueOf(d) > integer.valueOf(m))
                                        master.put(fieldName, integer.valueOf(d));
                                    else if (rule == 'Keep lowest value' && integer.valueOf(d) < integer.valueOf(m))
                                        master.put(fieldName, integer.valueOf(d));
                                }
                                else if (dt == Schema.DisplayType.Double || dt == Schema.DisplayType.Currency || dt == Schema.DisplayType.Percent)
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
                                        if (m == '')
                                            master.put(fieldName, Date.valueof(d));
                                        else if (rule == 'Keep earliest value' && Date.valueof(d) < Date.valueof(m))
                                            master.put(fieldName, Date.valueof(d));
                                        else if (rule == 'Keep latest value' && Date.valueof(d) > Date.valueof(m))
                                            master.put(fieldName, Date.valueof(d));
                                    }
                                }
                                else if (dt == Schema.DisplayType.DateTime)
                                {
                                    if (rule != 'Keep master value' && d != '')
                                    {
                                        if (m == '')
                                            master.put(fieldName, DateTime.valueOf(d));
                                        else if (rule == 'Keep earliest value' && DateTime.valueOf(d) < DateTime.valueOf(m))
                                            master.put(fieldName, DateTime.valueOf(d));
                                        else if (rule == 'Keep latest value' && DateTime.valueOf(d) > DateTime.valueOf(m))
                                            master.put(fieldName, DateTime.valueOf(d));
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
                    
                    lObjectsMerged += dupes;
                    lSetsToProcess--;
                    lSetsProcessed++;

                    if (lSetsProcessed >= lTotalSets)
                    {
                        lInfo = 'Merging complete';
                        lSetsToProcess = 0;
                        lKeepMerging = false;
                    }
                    else
                        lKeepMerging = true;
                }
                else
                {
                    lInfo = 'Merging complete';
                    lSetsToProcess = 0;
                    lKeepMerging = false;
                }
            }
            else
            {
                lInfo = 'No sets to process';
                lSetsToProcess = 0;
                lKeepMerging = false;
            }
        }
        catch (Exception e)
        {
            lInfo = 'Error: ' + e;
            lKeepMerging = false;
        }
    }
    
    public void MergeAccounts()
    {
        try
        {
            aInfo = 'Merging in progress - please wait...';
            string fieldList = '';
            List <String> validMergeFields = new List<String>();
            Map<string, Schema.SObjectField> FieldMap = Schema.SObjectType.Account.fields.getMap();
            Set<string> FieldSet = FieldMap.keySet();
            
            for (string fieldName : FieldSet)
            {
                Schema.DescribeFieldResult field = (FieldMap.get(fieldName)).getDescribe();
    
                if (field.isUpdateable() && field.IsAccessible() && fieldName != 'Set_Number__c' && fieldName != 'Set_Master__c' && fieldName != 'Set_Processed__c' && fieldName != 'IsPartner')
                {
                    fieldList += fieldName + ', ';
                    validMergeFields.add(fieldName);
                }
            }
            
            fieldList = fieldList.substring(0, fieldList.length() - 2);
            string[] rules = hiddenField.split(';');
            hiddenField = '';
            
            if (aTotalSets > 0)
            {
               // Account[] setObject = [select Set_Number__c from Account where Set_Processed__c = false and Set_Number__c <> '' order by Set_Number__c asc limit 1];
                
                if (setObject.size() > 0)
                {
                    integer dupes = 0;
                    string setNo = string.valueOf(setObject[0].Set_Number__c);
                    aSetNo = setNo;
                    string soql = 'select ' + fieldList + ' from Account where Set_Number__c = \'' + setNo + '\' order by Set_Master__c desc';
                    Account[] duplicates = (Account[])Database.query(soql);
                    
                    if (duplicates.size() > 1)
                    {
                        Account master = duplicates[0];
                        
                        for (integer i = 1; i < duplicates.size(); i++)
                        {
                            Account duplicate = duplicates[i];
                            
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
                                        
                                if (dt == Schema.DisplayType.Integer)
                                {
                                    if (m == '') m = '0';
                                    if (d == '') d = '0';
                                    
                                    if (rule == 'Keep highest value' && integer.valueof(d) > integer.valueOf(m))
                                        master.put(fieldName, integer.valueOf(d));
                                    else if (rule == 'Keep lowest value' && integer.valueOf(d) < integer.valueOf(m))
                                        master.put(fieldName, integer.valueOf(d));
                                }
                                else if (dt == Schema.DisplayType.Double || dt == Schema.DisplayType.Currency || dt == Schema.DisplayType.Percent)
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
                                        if (m == '')
                                            master.put(fieldName, Date.valueof(d));
                                        else if (rule == 'Keep earliest value' && Date.valueof(d) < Date.valueof(m))
                                            master.put(fieldName, Date.valueof(d));
                                        else if (rule == 'Keep latest value' && Date.valueof(d) > Date.valueof(m))
                                            master.put(fieldName, Date.valueof(d));
                                    }
                                }
                                else if (dt == Schema.DisplayType.DateTime)
                                {
                                    if (rule != 'Keep master value' && d != '')
                                    {
                                        if (m == '')
                                            master.put(fieldName, DateTime.valueOf(d));
                                        else if (rule == 'Keep earliest value' && DateTime.valueOf(d) < DateTime.valueOf(m))
                                            master.put(fieldName, DateTime.valueOf(d));
                                        else if (rule == 'Keep latest value' && DateTime.valueOf(d) > DateTime.valueOf(m))
                                            master.put(fieldName, DateTime.valueOf(d));
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
                    
                    aObjectsMerged += dupes;
                    aSetsToProcess--;
                    aSetsProcessed++;

                    if (aSetsProcessed >= aTotalSets)
                    {
                        aInfo = 'Merging complete';
                        aSetsToProcess = 0;
                        aKeepMerging = false;
                    }
                    else
                        aKeepMerging = true;
                }
                else
                {
                    aInfo = 'Merging complete';
                    aSetsToProcess = 0;
                    aKeepMerging = false;
                }
            }
            else
            {
                aInfo = 'No sets to process';
                aSetsToProcess = 0;
                aKeepMerging = false;
            }
        }
        catch (Exception e)
        {
            aInfo = 'Error: ' + e;
            aKeepMerging = false;
        }
    }

*/

/*

public class MultipleMergeControllerTest
{
   public static testmethod void testMultipleMergeController()
   {
       Date d1 = Date.parse('02/01/2012');
       Date d2 = Date.parse('01/01/2012');
       DateTime dt1 = DateTime.newInstance(d1.year(), d1.month(), d1.day());
       DateTime dt2 = DateTime.newInstance(d2.year(), d2.month(), d2.day());
       MultipleMergeController mmc = new MultipleMergeController();
       Contact c1 = new Contact(LastName = 'Test1', Phone = '0208123456', BirthDate = d1, DoNotCall = false, Set_Number__c = '1', Set_Master__c = true);
       Contact c2 = new Contact(LastName = 'Test2', Phone = '02081234567',BirthDate = d2, DoNotCall = true, Set_Number__c = '1', Set_Master__c = false);
       insert c1;
       insert c2;
       c1 = [select Id, LastName, Phone, BirthDate, DoNotCall, Set_Number__c, Set_Master__c  from Contact where LastName = 'Test1'];
       c2 = [select Id, LastName, Phone, BirthDate, DoNotCall, Set_Number__c, Set_Master__c  from Contact where LastName = 'Test2'];
       System.assertEquals('Test1', c1.LastName);
       System.assertEquals('Test2', c2.LastName);
       System.assertEquals('1', c1.Set_Number__c);
       System.assertEquals('1', c2.Set_Number__c);
       System.assertEquals(true, c1.Set_Master__c);
       System.assertEquals(false, c2.Set_Master__c);
       mmc.GetSetCounts();
       mmc.getContactPageBlockSection();
       mmc.getLeadPageBlockSection();
       mmc.getAccountPageBlockSection();
       mmc.GetFields('Contact');
       mmc.GetFields('Lead');
       mmc.GetFields('Account');
       mmc.SaveContactMergeRules();
       mmc.SaveLeadMergeRules();
       mmc.SaveAccountMergeRules();
       Component.Apex.SelectList sl = new Component.Apex.SelectList();
       mmc.AddSelectOption(sl, '');
       mmc.hiddenField = 'AccountId,Keep longest value;AssistantName,Keep longest value;AssistantPhone,Keep longest value;Birthdate,Keep earliest value;CCR_CLAM__DoNotCall,' +
                         'Keep true value;CCR_CLAM__Currency__c,Keep highest value;CCR_CLAM__Date__c,Keep earliest value;CCR_CLAM__Datetime__c,Keep earliest value;' + 
                         'Department,Keep longest value;Description,Keep longest value;Email,Keep longest value;CCR_CLAM__Email__c,Keep longest value;EmailBouncedDate,Keep earliest value;' + 
                         'EmailBouncedReason,Keep longest value;Fax,Keep longest value;FirstName,Keep longest value;HomePhone,Keep longest value;Jigsaw,Keep longest value;' + 
                         'LastName,Keep longest value;LeadSource,Keep longest value;CCR_CLAM__Lookup_Relationship__c,Keep longest value;MailingCity,Keep longest value;' + 
                         'MailingCountry,Keep longest value;MailingPostalCode,Keep longest value;MailingState,Keep longest value;MailingStreet,Keep longest value;' + 
                         'MobilePhone,Keep longest value;CCR_CLAM__Multipicklist__c,Keep all values;CCR_CLAM__Number__c,Keep highest value;OtherCity,Keep longest value;' + 
                         'OtherCountry,Keep longest value;OtherPhone,Keep longest value;OtherPostalCode,Keep longest value;OtherState,Keep longest value;OtherStreet,Keep longest value;' + 
                         'OwnerId,Keep longest value;;Phone,Keep longest value;CCR_CLAM__Phone__c,Keep longest value;CCR_CLAM__Integer__c,Keep highest value;' + 
                         'CCR_CLAM__Picklist__c,Keep longest value;ReportsToId,Keep longest value;Salutation,Keep longest value;CCR_CLAM__Text__c,Keep longest value;' + 
                         'CCR_CLAM__TextArea__c,Keep longest value;CCR_CLAM__TextAreaLong__c,Keep longest value;CCR_CLAM__TextAreaRich__c,Keep longest value;' + 
                         'CCR_CLAM__TextEncrypted__c,Keep longest value;Title,Keep longest value;CCR_CLAM__URL__c,Keep longest value';
       mmc.MergeContacts();
       c1.Phone = '02081234567';
       c1.BirthDate = d2;
       c1.DoNotCall = true;
       update c1;
       c2 = new Contact(LastName = 'Test2', Phone = '0208123456', BirthDate = d1, DoNotCall = false, Set_Number__c = '1', Set_Master__c = false);
       insert c2;
       mmc.GetSetCounts();
       mmc.hiddenField = 'AccountId,Keep shortest value;AssistantName,Keep shortest value;AssistantPhone,Keep shortest value;Birthdate,Keep latest value;CCR_CLAM__DoNotCall,' +
                         'Keep false value;CCR_CLAM__Currency__c,Keep shortest value;CCR_CLAM__Date__c,Keep latest value;CCR_CLAM__Datetime__c,Keep latest value;' + 
                         'Department,Keep shortest value;Description,Keep shortest value;Email,Keep shortest value;CCR_CLAM__Email__c,Keep shortest value;EmailBouncedDate,Keep latest value;' + 
                         'EmailBouncedReason,Keep shortest value;Fax,Keep shortest value;FirstName,Keep shortest value;HomePhone,Keep shortest value;Jigsaw,Keep shortest value;' + 
                         'LastName,Keep shortest value;LeadSource,Keep shortest value;CCR_CLAM__Lookup_Relationship__c,Keep shortest value;MailingCity,Keep shortest value;' + 
                         'MailingCountry,Keep shortest value;MailingPostalCode,Keep shortest value;MailingState,Keep shortest value;MailingStreet,Keep shortest value;' + 
                         'MobilePhone,Keep shortest value;CCR_CLAM__Multipicklist__c,Keep no values;CCR_CLAM__Number__c,Keep lowest value;OtherCity,Keep shortest value;' + 
                         'OtherCountry,Keep shortest value;OtherPhone,Keep shortest value;OtherPostalCode,Keep shortest value;OtherState,Keep shortest value;OtherStreet,Keep shortest value;' + 
                         'OwnerId,Keep shortest value;Phone,Keep shortest value;CCR_CLAM__Phone__c,Keep shortest value;CCR_CLAM__Integer__c,Keep lowest value;' + 
                         'CCR_CLAM__Picklist__c,Keep shortest value;ReportsToId,Keep shortest value;Salutation,Keep shortest value;CCR_CLAM__Text__c,Keep shortest value;' + 
                         'CCR_CLAM__TextArea__c,Keep shortest value;CCR_CLAM__TextAreaLong__c,Keep shortest value;CCR_CLAM__TextAreaRich__c,Keep shortest value;' + 
                         'CCR_CLAM__TextEncrypted__c,Keep shortest value;Title,Keep shortest value;CCR_CLAM__URL__c,Keep shortest value';
       mmc.MergeContacts();
       
       Lead l1 = new Lead(LastName = 'Test1', Company = 'Lead', Phone = '0208123456', DoNotCall = false, NumberOfEmployees = 5, Set_Number__c = '1', Set_Master__c = true);
       Lead l2 = new Lead(LastName = 'Test2', Company = 'Lead', Phone = '02081234567', DoNotCall = true, NumberOfEmployees = 6, Set_Number__c = '1', Set_Master__c = false);
       insert l1;
       insert l2;
       l1 = [select Id, LastName, Company, Phone, DoNotCall, NumberOfEmployees, Set_Number__c, Set_Master__c  from Lead where LastName = 'Test1'];
       l2 = [select Id, LastName, Company, Phone, DoNotCall, NumberOfEmployees, Set_Number__c, Set_Master__c  from Lead where LastName = 'Test2'];
       System.assertEquals('Test1', l1.LastName);
       System.assertEquals('Test2', l2.LastName);
       System.assertEquals('1', l1.Set_Number__c);
       System.assertEquals('1', l2.Set_Number__c);
       System.assertEquals(true, l1.Set_Master__c);
       System.assertEquals(false, l2.Set_Master__c);
       System.assertEquals(5, l1.NumberOfEmployees);
       System.assertEquals(6, l2.NumberOfEmployees);
       mmc.GetSetCounts();
       mmc.hiddenField = 'AnnualRevenue,Keep highest value;CCR_CLAM__DoNotCall,Keep true value;City,Keep longest value;Company,Keep longest value;Country,Keep longest value;' + 
                         'CCR_CLAM__Currency__c,Keep highest value;CCR_CLAM__Date__c,Keep earliest value;CCR_CLAM__Datetime__c,Keep earliest value;Description,Keep longest value;' + 
                         'Email,Keep longest value;CCR_CLAM__Email__c,Keep longest value;EmailBouncedDate,Keep earliest value;EmailBouncedReason,Keep longest value;Fax,Keep longest value;' + 
                         'FirstName,Keep longest value;Industry,Keep longest value;IsUnreadByOwner,Keep true value;Jigsaw,Keep longest value;' + 
                         'LastName,Keep longest value;LeadSource,Keep longest value;CCR_CLAM__Lookup_Relationship__c,Keep longest value;MobilePhone,Keep longest value;' + 
                         'CCR_CLAM__Multipicklist__c,Keep all values;CCR_CLAM__Number__c,Keep highest value;NumberOfEmployees,Keep highest value;OwnerId,Keep longest value;' + 
                         'CCR_CLAM__Percent__c,Keep highest value;Phone,Keep longest value;CCR_CLAM__Phone__c,Keep longest value;CCR_CLAM__Picklist__c,Keep longest value;' + 
                         'PostalCode,Keep longest value;Rating,Keep longest value;Salutation,Keep longest value;State,Keep longest value;Status,Keep longest value;Street,Keep longest value;' + 
                         'CCR_CLAM__Text__c,Keep longest value;CCR_CLAM__TextArea__c,Keep longest value;CCR_CLAM__TextAreaLong__c,Keep longest value;CCR_CLAM__TextAreaRich__c,Keep longest value;' + 
                         'CCR_CLAM__TextEncrypted__c,Keep longest value;Title,Keep longest value;CCR_CLAM__URL__c,Keep longest value;Website,Keep longest value';
       mmc.MergeLeads();
       l1.Phone = '02081234567';
       l1.DoNotCall = true;
       l1.NumberOfEmployees = 6;
       update l1;
       l2 = new Lead(LastName = 'Test2', Company = 'Lead', Phone = '0208123456', DoNotCall = false, NumberOfEmployees = 5, Set_Number__c = '1', Set_Master__c = false);
       insert l2;
       mmc.GetSetCounts();
       mmc.hiddenField = 'AnnualRevenue,Keep lowest value;CCR_CLAM__DoNotCall,Keep false value;City,Keep shortest value;Company,Keep shortest value;Country,Keep shortest value;' + 
                         'CCR_CLAM__Currency__c,Keep lowest value;CCR_CLAM__Date__c,Keep latest value;CCR_CLAM__Datetime__c,Keep latest value;Description,Keep shortest value;' + 
                         'Email,Keep shortest value;CCR_CLAM__Email__c,Keep shortest value;EmailBouncedDate,Keep latest value;EmailBouncedReason,Keep shortest value;Fax,Keep shortest value;' + 
                         'FirstName,Keep shortest value;Industry,Keep shortest value;IsUnreadByOwner,Keep false value;Jigsaw,Keep shortest value;' + 
                         'LastName,Keep shortest value;LeadSource,Keep shortest value;CCR_CLAM__Lookup_Relationship__c,Keep shortest value;MobilePhone,Keep shortest value;' + 
                         'CCR_CLAM__Multipicklist__c,Keep no values;CCR_CLAM__Number__c,Keep lowest value;NumberOfEmployees,Keep lowest value;OwnerId,Keep shortest value;' + 
                         'CCR_CLAM__Percent__c,Keep lowest value;Phone,Keep shortest value;CCR_CLAM__Phone__c,Keep shortest value;CCR_CLAM__Picklist__c,Keep shortest value;' + 
                         'PostalCode,Keep shortest value;Rating,Keep shortest value;Salutation,Keep shortest value;State,Keep shortest value;Status,Keep shortest value;Street,Keep shortest value;' + 
                         'CCR_CLAM__Text__c,Keep shortest value;CCR_CLAM__TextArea__c,Keep shortest value;CCR_CLAM__TextAreaLong__c,Keep shortest value;CCR_CLAM__TextAreaRich__c,Keep shortest value;' + 
                         'CCR_CLAM__TextEncrypted__c,Keep shortest value;Title,Keep shortest value;CCR_CLAM__URL__c,Keep shortest value;Website,Keep shortest value';
       mmc.MergeLeads();
       
       Account a1 = new Account(Name = 'Test1', Phone = '0208123456', NumberOfEmployees = 5, Set_Number__c = '1', Set_Master__c = true);
       Account a2 = new Account(Name = 'Test2', Phone = '02081234567', NumberOfEmployees = 6, Set_Number__c = '1', Set_Master__c = false);
       insert a1;
       insert a2;
       a1 = [select Id, Name, Phone, NumberOfEmployees, Set_Number__c, Set_Master__c  from Account where Name = 'Test1'];
       a2 = [select Id, Name, Phone, NumberOfEmployees, Set_Number__c, Set_Master__c  from Account where Name = 'Test2'];
       System.assertEquals('Test1', a1.Name);
       System.assertEquals('Test2', a2.Name);
       System.assertEquals('1', a1.Set_Number__c);
       System.assertEquals('1', a2.Set_Number__c);
       System.assertEquals(true, a1.Set_Master__c);
       System.assertEquals(false, a2.Set_Master__c);
       mmc.GetSetCounts();
       mmc.hiddenField = 'AccountNumber,Keep longest value;AccountSource,Keep longest value;AnnualRevenue,Keep highest value;BillingCity,Keep longest value;BillingCountry,Keep longest value;' + 
                         'BillingPostalCode,Keep longest value;BillingState,Keep longest value;BillingStreet,Keep longest value;CCR_CLAM__DoNotCall,Keep true value;' + 
                         'CCR_CLAM__Currency__c,Keep highest value;CCR_CLAM__Date__c,Keep earliest value;CCR_CLAM__Datetime__c,Keep earliest value;Description,Keep longest value;' + 
                         'CCR_CLAM__Email__c,Keep longest value;Fax,Keep longest value;Industry,Keep longest value;Jigsaw,Keep longest value;' + 
                         'CCR_CLAM__Lookup_Relationship__c,Keep longest value;CCR_CLAM__Multipicklist__c,Keep all values;Name,Keep longest value;CCR_CLAM__Number__c,Keep highest value;' + 
                         'NumberOfEmployees,Keep highest value;OwnerId,Keep longest value;Ownership,Keep longest value;ParentId,Keep longest value;CCR_CLAM__Percent__c,Keep highest value;' + 
                         'Phone,Keep longest value;CCR_CLAM__Phone__c,Keep longest value;CCR_CLAM__Picklist__c,Keep longest value;Rating,Keep longest value;ShippingCity,Keep longest value;' + 
                         'ShippingCountry,Keep longest value;ShippingPostalCode,Keep longest value;ShippingState,Keep longest value;ShippingStreet,Keep longest value;Sic,Keep longest value;' + 
                         'SicDesc,Keep longest value;Site,Keep longest value;CCR_CLAM__Text__c,Keep longest value;CCR_CLAM__TextArea__c,Keep longest value;' + 
                         'CCR_CLAM__TextAreaLong__c,Keep longest value;CCR_CLAM__TextAreaRich__c,Keep longest value;CCR_CLAM__TextEncrypted__c,Keep longest value;TickerSymbol,Keep longest value;' + 
                         'Type,Keep longest value;CCR_CLAM__URL__c,Keep longest value;Website,Keep longest value';
        mmc.MergeAccounts();
        a1.Phone = '02081234567';
        a1.NumberOfEmployees = 6;
        update a1;
        a2 = new Account(Name = 'Test2', Phone = '0208123456', NumberOfEmployees = 5, Set_Number__c = '1', Set_Master__c = false);
        insert a2;
        mmc.GetSetCounts();
        mmc.hiddenField = 'AccountNumber,Keep shortest value;AccountSource,Keep shortest value;AnnualRevenue,Keep lowest value;BillingCity,Keep shortest value;BillingCountry,Keep shortest value;' + 
                         'BillingPostalCode,Keep shortest value;BillingState,Keep shortest value;BillingStreet,Keep shortest value;CCR_CLAM__DoNotCall,Keep false value;' + 
                         'CCR_CLAM__Currency__c,Keep lowest value;CCR_CLAM__Date__c,Keep latest value;CCR_CLAM__Datetime__c,Keep latest value;Description,Keep shortest value;' + 
                         'CCR_CLAM__Email__c,Keep shortest value;Fax,Keep shortest value;Industry,Keep shortest value;Jigsaw,Keep shortest value;' + 
                         'CCR_CLAM__Lookup_Relationship__c,Keep shortest value;CCR_CLAM__Multipicklist__c,Keep no values;Name,Keep shortest value;CCR_CLAM__Number__c,Keep lowest value;' + 
                         'NumberOfEmployees,Keep lowest value;OwnerId,Keep shortest value;Ownership,Keep shortest value;ParentId,Keep shortest value;CCR_CLAM__Percent__c,Keep lowest value;' + 
                         'Phone,Keep shortest value;CCR_CLAM__Phone__c,Keep shortest value;CCR_CLAM__Picklist__c,Keep shortest value;Rating,Keep shortest value;ShippingCity,Keep shortest value;' + 
                         'ShippingCountry,Keep shortest value;ShippingPostalCode,Keep shortest value;ShippingState,Keep shortest value;ShippingStreet,Keep shortest value;Sic,Keep shortest value;' + 
                         'SicDesc,Keep shortest value;Site,Keep shortest value;CCR_CLAM__Text__c,Keep shortest value;CCR_CLAM__TextArea__c,Keep shortest value;' + 
                         'CCR_CLAM__TextAreaLong__c,Keep shortest value;CCR_CLAM__TextAreaRich__c,Keep shortest value;CCR_CLAM__TextEncrypted__c,Keep shortest value;TickerSymbol,Keep shortest value;' + 
                         'Type,Keep shortest value;CCR_CLAM__URL__c,Keep shortest value;Website,Keep shortest value';
        mmc.MergeAccounts();
   }
}


*/