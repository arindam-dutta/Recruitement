@isTest

private class TestBatchUpdateCoverLetter {

static testmethod void test() {

	String query = 'select Id, Name, new_position__c from position__c where id in ( select position__c from job_application__c where status__c = \'Extend an Offer\')' +
	 				' and new_position__c <> \'Closed - Filled\' ';
	
	Position__c[] pos = new List<position__c>();
	for (integer p1 = 0; p1 < 2; p1++)
	{
		position__c p = new position__c(
			name = 'Job Title' + p1,
			new_position__c = 'New Position',
			type__c = 'Full Time',
			functional__c = 'Warehousing',
			min_pay__c = 40000,
			max_pay__c = 50000);
	
	pos.add(p);
    
    }
	insert pos;

	Job_Application__c[] j1 = new List<Job_Application__c>();
	for (integer i=0; i<2; i++) 
	{
			Job_Application__c j = new Job_Application__c(
				Candidate__c = 'a03U0000001ValPIAS' ,
				Status__c = 'Extend an Offer',
				//Position__c = 'a02U0000000hfGqIAI',
				Position__c = pos[i].Id,
				Cover_Letter__c = 'Description');
	
	j1.add(j);
			
	}
	insert j1;
		
	Test.StartTest();
	BatchUpdateCoverLetter b = new BatchUpdateCoverLetter(query);
	Database.ExecuteBatch(b);
	Test.StopTest();
	
	Integer i = [Select count() from position__c where new_position__c <> 'Closed - Filled'];	 				 
	System.assertEquals(i, 0);
}

}