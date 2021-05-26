public class erp_AutoCompleteBoxCtrl {
	
    @InvocableMethod(label = 'Get Branch Id')
    public static List<string> getUserBranchId(List<String> requests) {
        String userAssignmentId = requests[0];
        List<string> lstBranchId = new List<string>();
        List<User_Branch_Assignment__c> lstUser = [select id,Business_Unit__c from User_Branch_Assignment__c where User_Assignment__c =: userAssignmentId limit 1];
        if(!lstUser.isEmpty()){
            lstBranchId.add(lstUser[0].Business_Unit__c);
        }
        return lstBranchId;
    }
}