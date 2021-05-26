public class erp_UserAssingmentService {
    /**
	* Method to update job contacts based on Store Product change
	* */
    public static Boolean updateJobContactsAndTasks(List<User_Additional_Assignment__c> jobContactsToUpdate, 
                                                    User newUser, Boolean reassignTasks){
        Boolean updated = false;
        Set<Id> previousUserId = new Set<Id>();
        Set<Id> storeIds = new Set<Id>();
        Set<Id> productIds = new Set<Id>();
        for(User_Additional_Assignment__c oldJobContact : jobContactsToUpdate){
            previousUserId.add(oldJobContact.Previous_User__c);
            productIds.add(oldJobContact.Product2__c);
            storeIds.add(oldJobContact.Store__c);
        }
        
        List<String> jobStatus = new List<String>{ JobManagementConstant.JOB_STATUS_JOB_CONTRACT_VERIFIED,
                                                   JobManagementConstant.JOB_STATUS_PRODUCTION,
                                                   JobManagementConstant.JOB_STATUS_CONTRACT_RECEIVED,
                                                   JobManagementConstant.JOB_STATUS_INSTALLATION};                                               
        List<Job_Contacts__c> previousJobContacts = [SELECT Id, Name, User__c, Customer_Order__c,
                                                         	 Job__r.giic_Product_Reference__c 
                                                         	 FROM Job_Contacts__c 
                                                             WHERE User__c IN :previousUserId
                                                             AND Customer_Order__r.Order_Status__c IN :jobStatus
                                                             AND Job__r.giic_Store__c IN :storeIds
                                                             AND Job__r.giic_Product_Reference__c IN :productIds];
        Set<Id> customerOrderId = new Set<Id>();
        for(Job_Contacts__c previousJob : previousJobContacts){
            customerOrderId.add(previousJob.Customer_Order__c);
        }
                                                        
        List<Task> updateTaskOwnership = new List<Task>();
        //Map<Customer Order, List<Task>>
        Map<Id, List<Task>> previousUserTasks = new Map<Id, List<Task>>();
        List<Task> tskToReassign = new List<Task>();
        if(reassignTasks){
            updateTaskOwnership = [SELECT id, whatid, OwnerId, Product__c FROM TASK
                                   WHERE OwnerId IN :previousUserId 
                                   AND Status IN ('Open')
                                   AND WHAT.type = 'Customer_Order__c' 
                                   AND WhatId IN :customerOrderId];
            
            for(Task openTsk : updateTaskOwnership){
                if(previousUserTasks.containsKey(openTsk.whatid)){
                    previousUserTasks.get(openTsk.whatid).add(openTsk);
                }else{
                    previousUserTasks.put(openTsk.whatid, new List<Task>{openTsk});
                }
            }
        }
        if(!previousJobContacts.isEmpty()){
            String oldUser = '';
            for(Job_Contacts__c jobContact: previousJobContacts) {
                oldUser = jobContact.User__c;
                jobContact.Name = newUser.Name;
                jobContact.User__c = newUser.Id;
                if(previousUserTasks.containsKey(jobContact.Customer_Order__c)){
                    for(Task tsk : previousUserTasks.get(jobContact.Customer_Order__c)){
                        tsk.Previous_User__c = oldUser;
                        tsk.OwnerId = newUser.Id;
                        tskToReassign.add(tsk);
                    }
                }
            }
        }
        try{
            update previousJobContacts;
            if(!tskToReassign.isEmpty()){
                update tskToReassign;
            }
            updated = true;
        }catch(Exception e){
            System.debug(Logginglevel.ERROR, 'Exception occured when updating Job Contacts '+e);
        }
        return updated;
    }
}