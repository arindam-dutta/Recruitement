global class BatchApexJobApplication implements Database.Batchable<sObject>{

// Execute Logic
       global void execute(Database.BatchableContext BC, List<Job_Application__c>scope){
       	
			For (Job_Application__c j: scope)
			{
				System.debug ('in for...'+j.Cover_letter__c);
				j.Cover_Letter__c = 'Offer document sent to HR System. Updated by Batch Apex';
			}              
              // Logic to be Executed batch wise           
            update scope;
       }

// Start Method
        global Database.QueryLocator start(Database.BatchableContext BC){
		
		//String Query = 'Select a.ahm__Status__c, a.Name, a.Id, (Select Id, ahm__HCP__c, ahm__RSVP_Status__c, ahm__Role__c From ahm__Participants__r where ahm__Role__c = 'Attendee'), (Select Id, ahm__Spend_Type__c From ahm__Cap_Utilizations__r ) From ahm__Interaction__c a where a.name = 'INT-0000109';
		 String query = 'Select Name, Id, Cover_Letter__c From Job_Application__c where Status__c = \'Extend an Offer\' ';
         return Database.getQueryLocator(query);
        }
    
       global void finish(Database.BatchableContext BC){
            // Get the status of Batch Job
            AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
        						TotalJobItems, CreatedBy.Email, ExtendedStatus
        						from AsyncApexJob where Id = :bc.getJobId()];    
        						
			if (a.status == 'Completed')
			{
				 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

		        // Send the email to the job submitter
		        String[] toAddresses = new String[] {a.CreatedBy.Email};
		        mail.setToAddresses(toAddresses);
		        mail.setSenderDisplayName('Batch Processing');
		        mail.setSubject('InsertCapUtil  Status: ' + a.Status);
		            mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
		            ' batches with '+ a.NumberOfErrors + ' failures. ExtendedStatus: ' + a.ExtendedStatus);
		
		        // Add your attachment to the email.
		
		        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
				
			}
       }
    }
