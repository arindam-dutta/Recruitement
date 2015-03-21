Global class BatchUpdateCoverLetter implements Database.Batchable<sObject> {

	global final String query;
	
	global BatchUpdateCoverLetter(String q) {
		query = q;
	}
	
	global void execute(Database.BatchableContext BC, List<Position__c> scope){
		System.debug(system.today());
		For (Position__c pos: scope)
			{
			system.debug (pos.new_position__c);
				if (pos.new_position__c != 'Closed - Filled') {
					pos.new_position__c = 'Closed - Filled';
					pos.Close_Date__c = system.today();
					}
			}              
              // Logic to be Executed batch wise           
            update scope;
            //Database.emptyRecycleBin(scope);
	}

	global Database.QueryLocator start(Database.BatchableContext BC){
	
	return Database.getQueryLocator(query);
	}
	
	global void finish(Database.BatchableContext BC){
       
	}
}	
