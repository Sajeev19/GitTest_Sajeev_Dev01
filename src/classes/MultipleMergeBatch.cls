global class MultipleMergeBatch implements Database.Batchable<SObject>{
    
        global MultipleMergeBatch (){
                   // Batch Constructor
        }
       
        // Start Method
        global Database.QueryLocator start(Database.BatchableContext BC){
            String query = 'Select Name From Contact';
         return Database.getQueryLocator(query);
        }
     
      // Execute Logic
       global void execute(Database.BatchableContext BC, List<SObject> scope){
             for(Contact c : (List<Contact>) scope)    {
                 System.debug(c.Name);
             }
     
       }
     
       global void finish(Database.BatchableContext BC){
            // Logic to be Executed at finish
       }
    }
  
  
  /*
  
  global class BatchAttachmentReparentPDFsToAccount implements Database.Batchable<sObject>, Database.Stateful
{
    private String listSize;

    global Database.QueryLocator start( Database.BatchableContext BC ) 
    {
        return Database.getQueryLocator( [SELECT Id,(Select Id From Contracts)  FROM Account WHERE (Type = 'Subscriber' OR Type = 'Ex-Subscriber' OR Type = 'Division' OR Type = 'EDU SUBSCRIBER')] );
    }

    global void execute( Database.BatchableContext BC, List<sObject> scope )
    {
        Set<Id> accountIdSet = new Set<Id> {};
        Map<Id,Id> contractToAccountMap=new Map<Id,Id>();

        for( Account acc : (List<Account>)scope )
        {
            accountIdSet.add( acc.Id );      

            for( Contract ct : acc.Contracts )
            {
                if( !contractToAccountMap.containsKey( ct.Id ) )
                {
                  contractToAccountMap.put( ct.Id, acc.Id );
                }
            }
        }

        // Lists of attachments to be created then deleted
        List<Attachment> attachmentsToDelete = new List<Attachment>(); 
        List<Attachment> attachmentsToCreate = new List<Attachment>(); 


        // Attachment tempAtt = new Attachment();
        // Update the parentId of the attachment, changing from the ContractId to the related AccountId
        List<Attachment> attachments = [SELECT Name, Id, Body, ParentId From Attachment WHERE ((Name LIKE '%.pdf') AND (ParentId IN :contractToAccountMap.keySet() ))];
        for(Attachment att: attachments ){
            if(contractToAccountMap.get(att.ParentID)!=null){
                Attachment tempAtt = new Attachment ( name = att.name, body = att.body, parentId = contractToAccountMap.get(att.ParentID));
                // tempAtt.ParentID = contractToAccountMap.get(att.ParentID);
                    attachmentsToCreate.add(tempAtt);
                    attachmentsToDelete.add(att);
            }
        }

        // Update the list of attachments
        insert attachmentsToCreate;
        delete attachmentsToDelete;
        System.debug('No. of attachments to be created; ' + attachmentsToCreate.size());

        // Return the no. of attachments that have been reparented
        listSize =  String.valueOf(attachmentsToCreate.size());
        listSize += ' attachments have been reparented to their root Accounts.';

    }

    global void finish( Database.BatchableContext BC )
    {
        // send an email with listSize?
    }

}

*/