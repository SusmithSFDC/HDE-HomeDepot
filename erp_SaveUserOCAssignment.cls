public class erp_SaveUserOCAssignment {
    
    @InvocableMethod(label = 'Save OC Assignment')
    public static void saveOCUserAssignment(List<FlowInput> requests) {
        FlowInput request = requests[0];
        List<User_Branch_Assignment__c> userBranchAssignment = new List<User_Branch_Assignment__c>();
        system.debug('request+'+request);
        User fieldUser = getUserDetails(request.userAssignmentRecordId);
        Set<String> selectedProducts = new Set<String>();
        if(request.selectedProductIds != null){
            selectedProducts.addAll(request.selectedProductIds);
        }
        userBranchAssignment = getCurrentAssignment(request.userAssignmentRecordId);
        List<User_Additional_Assignment__c> additionalAssignments = new List<User_Additional_Assignment__c>(); 
        List<User_Branch_Assignment__c> userBranchAssignments = new List<User_Branch_Assignment__c>();
        List<User_Additional_Assignment__c> currentAdditionalAssingments = getUserAdditionalAssignment(request.userAssignmentRecordId);
        for(String product : selectedProducts){
            additionalAssignments.add(new User_Additional_Assignment__c(Type__c ='Product', 
                                                                        User__c = fieldUser.Id, 
                                                                        Product2__c = product,
                                                                        User_Assignment__c = request.userAssignmentRecordId));
        }
        
        if(!request.selectedTasks.isEmpty()){
            for(string task : request.selectedTasks){          
                erp_CheckboxGroupOptions erpTask = (erp_CheckboxGroupOptions) JSON.deserialize(task, erp_CheckboxGroupOptions.class);
                additionalAssignments.add(new User_Additional_Assignment__c(Type__c = 'Task', 
                                                                            Task__c = erpTask.label,                                                                            
                                                                            User__c = fieldUser.Id,
                                                                            User_Assignment__c = request.userAssignmentRecordId));                                                    
            }
        }
        
        if(!request.selectedVendors.isEmpty()){
            for(string vendor : request.selectedVendors){          
                erp_CheckboxGroupOptions erpVendor = (erp_CheckboxGroupOptions) JSON.deserialize(vendor, erp_CheckboxGroupOptions.class);
                additionalAssignments.add(new User_Additional_Assignment__c(Type__c = 'Vendor', 
                                                                            Vendor__c = erpVendor.label,                                                                            
                                                                            User__c = fieldUser.Id,
                                                                            User_Assignment__c = request.userAssignmentRecordId));                                                    
            }
        }
        
        if(!request.selectedDivision.isEmpty()){
            Decimal priority = 1;
            for(string division : request.selectedDivision){                
                erp_CheckboxGroupOptions erpDivision = (erp_CheckboxGroupOptions) JSON.deserialize(division, erp_CheckboxGroupOptions.class);
                additionalAssignments.add(new User_Additional_Assignment__c(Type__c = 'Division Priority', 
                                                                            Division__c = erpDivision.value,                                                                            
                                                                            User__c = fieldUser.Id,
                                                                            User_Assignment__c = request.userAssignmentRecordId,
                                                                            Priority__c = priority));
                priority++;
            }
        }
        
        if(!request.selectedBranches.isEmpty()){            
            for(string branch : request.selectedBranches){
                erp_CheckboxGroupOptions erpBranch = (erp_CheckboxGroupOptions) JSON.deserialize(branch, erp_CheckboxGroupOptions.class);                
                userBranchAssignments.add(new User_Branch_Assignment__c(
                    Business_Unit__c = erpBranch.value,
                    User__c = fieldUser.Id,
                    Type__c = 'Home',
                    User_Assignment__c = request.userAssignmentRecordId));
                
                
            }
        }
        
        if(String.isNotBlank(request.selectedRegions)){
            system.debug('request.selectedRegions+'+request.selectedRegions);
            List<ERP_FlowDuallistboxController.jsonWrapper> lstRegions = (List<ERP_FlowDuallistboxController.jsonWrapper>) JSON.deserialize(request.selectedRegions, List<ERP_FlowDuallistboxController.jsonWrapper>.class);                
            for(ERP_FlowDuallistboxController.jsonWrapper reg : lstRegions){
                Decimal priority = 1;
                for(String selectedReg : reg.selectedRegions){                    
                    additionalAssignments.add(new User_Additional_Assignment__c(Type__c = 'Region Priority', 
                                                                                Region__c = selectedReg, 
                                                                                Division__c = reg.divisionId,
                                                                                User__c = fieldUser.Id,
                                                                                User_Assignment__c = request.userAssignmentRecordId,
                                                                                Priority__c = priority));
                    priority++;
                }
            }
        }
        if(currentAdditionalAssingments != null && !currentAdditionalAssingments.isEmpty() ){
            delete currentAdditionalAssingments;
        }
        if(!userBranchAssignment.isEmpty()){
            delete userBranchAssignment;
        }
        if(!additionalAssignments.isEmpty()){
            insert additionalAssignments;
        }
        if(!userBranchAssignments.isEmpty()){
            insert userBranchAssignments;
        }
    }
    
    private static User getUserDetails(String userAssignmentRecordId){
        
        String userId = [SELECT Id, Name, User__c FROM User_Assignment__c WHERE Id = :userAssignmentRecordId].User__c;
        User user = [SELECT Id, Name,Field_Role__c  FROM User WHERE Id = :userId];
        return user;
    }
    
    private static List<User_Additional_Assignment__c> getUserAdditionalAssignment(String userAssignmentRecordId){
        List<User_Additional_Assignment__c> userAssignments = [Select Id,Type__c,Product2__c,Store__c FROM User_Additional_Assignment__c
                                                               Where User_Assignment__c = :userAssignmentRecordId];
        return (!userAssignments.isEmpty())? userAssignments : null;
    }
    
    public static List<User_Branch_Assignment__c> getCurrentAssignment(String userAssignmentRecordId){        
        List<User_Branch_Assignment__c> userHomeBranchs = [Select Id, Business_Unit__c,User__c from User_Branch_Assignment__c
                                                           Where User_Assignment__c = :userAssignmentRecordId
                                                           And Type__c = 'Home'];
        
        return userHomeBranchs;
    }
    public class FlowInput{
        @InvocableVariable
        public String userAssignmentRecordId;
        @InvocableVariable
        public List<String> selectedDivision;
        @InvocableVariable
        public String selectedRegions;
        @InvocableVariable
        public List<String> selectedBranches;
        @InvocableVariable
        public List<String> selectedVendors;
        @InvocableVariable
        public List<String> selectedTasks;
        @InvocableVariable
        public List<String> selectedProductIds;
        
    }
}