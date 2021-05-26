public without sharing class ERP_TaskDetailUIController {
    public ERP_TaskDetailUIController() {

    }

    @AuraEnabled
    public static string getTaskRecordDetails( String recordId){
        List<Task> taskList = new List<Task>();
        taskList = [SELECT Id,Subject,Description,Job__r.Customer_Order__r.Name,Job__c,
                Product__r.Name,Job__r.Name, Job__r.ent_LMS_Lead_ID__c,

                Job_Status__c,grnk_Customer_Name__c,Job__r.Customer_Order__c,Vendor_Number__c,
                createdDate From Task WHERE Id =:recordId];

        TaskDetailWrapper objTaskWrapper = new TaskDetailWrapper();
        if(!taskList.isEmpty()) {
            objTaskWrapper.taskName = taskList[0].Subject;
            objTaskWrapper.description = String.isNotBlank(taskList[0].Description)
                    ? taskList[0].Description
                    : '';
            objTaskWrapper.customerOrderNumber = taskList[0].Job__c != NULL
                    && String.isNotBlank(taskList[0].Job__r.Customer_Order__r.Name)
                    ? taskList[0].Job__r.Customer_Order__r.Name
                    : '';
            objTaskWrapper.customerName = String.isNotBlank(taskList[0].grnk_Customer_Name__c)
                    ? taskList[0].grnk_Customer_Name__c
                    : '';
            objTaskWrapper.productName = taskList[0].Product__c != NULL
                    && String.isNotBlank(taskList[0].Product__r.Name)
                    ? taskList[0].Product__r.Name
                    : '';
            objTaskWrapper.jobNumber = taskList[0].Job__c != NULL
                    && String.isNotBlank(taskList[0].Job__r.Name)
                    ? taskList[0].Job__r.Name
                    : '';
            objTaskWrapper.lmsJobNumber = taskList[0].Job__c != NULL
                    && String.isNotBlank(taskList[0].Job__r.ent_LMS_Lead_ID__c)
                    ? taskList[0].Job__r.ent_LMS_Lead_ID__c
                    : '';
            objTaskWrapper.jobStatus = String.isNotBlank(taskList[0].Job_Status__c)
                    ? taskList[0].Job_Status__c
                    : '';
            objTaskWrapper.jobId = taskList[0].Job__c;
            objTaskWrapper.age = Math.abs((System.today()).daysBetween(Date.valueOf(taskList[0].createdDate))) +' days';
            objTaskWrapper.vendor = String.isNotBlank(taskList[0].Vendor_Number__c)
                    ? taskList[0].Vendor_Number__c
                    : '';
            objTaskWrapper.jobUrl = '/'+ taskList[0].Job__c;
            objTaskWrapper.customerOrderUrl = '/' + taskList[0].Job__r.Customer_Order__c;

        }

        return JSON.serialize(objTaskWrapper);
    }

    @AuraEnabled
    public static string getAllTasks(){
        List<Task> taskList = new List<Task>();
        List<TaskDetailWrapper> taskWrapperList = new List<TaskDetailWrapper>();
        taskList = [SELECT Id,Subject,Description,Job__r.Customer_Order__r.Name,Job__c,
                Product__r.Name,Job__r.Name, Job__r.ent_LMS_Lead_ID__c,
                Job_Status__c,grnk_Customer_Name__c,Job__r.Customer_Order__c,Vendor_Number__c
        From Task LIMIT 10];

        TaskDetailWrapper objTaskWrapper = new TaskDetailWrapper();
        if(!taskList.isEmpty()) {
            for (Task objTask : taskList) {
                objTaskWrapper.taskName = objTask.Subject;
                objTaskWrapper.description = String.isNotBlank(objTask.Description)
                        ? objTask.Description
                        : '';
                objTaskWrapper.customerOrderNumber = objTask.Job__c != NULL
                        && String.isNotBlank(objTask.Job__r.Customer_Order__r.Name)
                        ? objTask.Job__r.Customer_Order__r.Name
                        : '';
                objTaskWrapper.customerName = String.isNotBlank(objTask.grnk_Customer_Name__c)
                        ? objTask.grnk_Customer_Name__c
                        : '';
                objTaskWrapper.productName = objTask.Product__c != NULL
                        && String.isNotBlank(objTask.Product__r.Name)
                        ? objTask.Product__r.Name
                        : '';
                objTaskWrapper.jobNumber = objTask.Job__c != NULL
                        && String.isNotBlank(objTask.Job__r.Name)
                        ? objTask.Job__r.Name
                        : '';
                objTaskWrapper.lmsJobNumber = objTask.Job__c != NULL
                        && String.isNotBlank(objTask.Job__r.ent_LMS_Lead_ID__c)
                        ? objTask.Job__r.ent_LMS_Lead_ID__c
                        : '';
                objTaskWrapper.jobStatus = String.isNotBlank(objTask.Job_Status__c)
                        ? objTask.Job_Status__c
                        : '';
                objTaskWrapper.jobId = objTask.Job__c;
                objTaskWrapper.age = '5 Days';
                objTaskWrapper.vendor = String.isNotBlank(objTask.Vendor_Number__c)
                        ? objTask.Vendor_Number__c
                        : '';
                objTaskWrapper.jobUrl = '/'+ objTask.Job__c;
                objTaskWrapper.customerOrderUrl = '/' + objTask.Job__r.Customer_Order__c;
                taskWrapperList.add(objTaskWrapper);
            }
        }

        return JSON.serialize(taskWrapperList);
    }
    //Wrapper class to wrap component data which we need to display
    public class TaskDetailWrapper {
        public String jobUrl;
        public String customerOrderUrl;
        public String taskName;
        public String description;
        public String customerOrderNumber;
        public String customerName;
        public String productName;
        public String jobId;
        public String jobNumber;
        public String lmsJobNumber;
        public String jobStatus;
        public String age;
        public String vendor;
    }
}