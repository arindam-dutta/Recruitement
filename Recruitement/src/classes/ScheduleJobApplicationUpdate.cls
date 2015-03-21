global class ScheduleJobApplication implements Schedulable{
 
 // Execute method
    global void execute(SchedulableContext SC) {
    // Code to be executed when the schedule class wakes up
          // code
 
 
    // This section of code will schedule the next execution 10 minutes from now
   
	  datetime nextScheduleTime = system.now().addMinutes(10);
      string minute = string.valueof(nextScheduleTime.minute());
      string second = string.valueof(nextScheduleTime.second ());
      string cronvalue = second+' '+minute+' * * * ?' ;
      string jobName = 'BatchApexJobApplication' +
	  	nextScheduleTime.format('hh:mm');
 
    ScheduleJobApplication s = new ScheduleJobApplication();
    system.schedule(jobName, cronvalue, s);
 
    // this section of code will abort the current schedule job
   // system.abortJob(sc.getTriggerId());
 
   }
 }