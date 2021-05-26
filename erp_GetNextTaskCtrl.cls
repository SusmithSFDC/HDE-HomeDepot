public class erp_GetNextTaskCtrl {
    
    @AuraEnabled(cacheable=true)
    public static String getNextTask(String userId) {
        List<erp_TaskAssignment> unclaimedTasks = new List<erp_TaskAssignment>();
        populateTestData(unclaimedTasks);
       	unclaimedTasks.sort();
        for(erp_TaskAssignment unclaimedTask : unclaimedTasks){
            System.debug('Division -> ' +unclaimedTask.divisionPriority 
                         +' Region -> ' +unclaimedTask.regionPriority
                         +' Product -> ' +unclaimedTask.productPriority +' Vendor -> ' +unclaimedTask.vendorPriority
                         +' Task -> '+unclaimedTask.taskPriority +' Job Age -> ' +unclaimedTask.jobAge
                         +'Task Name ->' +unclaimedTask.taskName);
        }
        System.debug('>>> '+unclaimedTasks[0].taskName);
        return unclaimedTasks[0].taskName;
    }
    
    
    private static void populateTestData(List<erp_TaskAssignment> unclaimedTasks){
        for(Integer i=1; i<11; i++){
            Integer recordNumber = i+1;
            String divisionName = 'Division' + String.valueOf(math.mod(i, 2));
            unclaimedTasks.add(new erp_TaskAssignment(String.valueOf(recordNumber), 'Task '+recordNumber,
                                                       divisionName, math.mod(i, 2),
                                                      'Region '+recordNumber, Integer.valueof((Math.random() * 2)),
                                                      'Product '+recordNumber, Integer.valueof((Math.random() * 3)),
                                                      'Vendor '+recordNumber, Integer.valueof((Math.random() * 5)),
                                                      Integer.valueof((Math.random() * 10)), Integer.valueof((Math.random() * 50))));
        }
    }
}