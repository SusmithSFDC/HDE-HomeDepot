/**
* Created by AXP8376 on 12/1/2020.
* Class to Create User_Assignment__c record for roles mentioned in User_Assignment_Roles Custom Label
*/

public class erp_CreateUserAssignment extends TriggerHandler {
    
    @Future
    public static void createUserAssignments(List<Id> userList) {
        List<User_Assignment__c> userAssignList = new List<User_Assignment__c>();
        System.debug('userList' + userList);
        try {
            for (Id user : userList) {
                User_Assignment__c userAssignment = new User_Assignment__c();
                userAssignment.User__c = user;
                userAssignment.unique_name__c = user;
                userAssignList.add(userAssignment);
            }
            
            if (!userAssignList.isEmpty() && userAssignList.size() > 0) {
                Database.insert(userAssignList);
            }
        }
        catch(Exception ex) {
            System.debug('Exception occured when creating user assignments ::' +ex);
            giic_LoggerUtil.addLog(new giic_Logger__c(Description__c = ex.getStackTraceString(),
                                                      Error__c = true,Method__c = ex.getMessage()+' Line Number --->' +ex.getLineNumber()+' Type --->' +ex.getTypeName()));
            giic_LoggerUtil.saveLogs();
        }
    }
    
    public  override void invoke() {
        List<Id> newUserAssign = new List<Id>() ;
        Set<Id> userIDs = new Set<Id>();
        List<String> lstAcceptableRoles = Label.User_Assignment_Roles.split(',');
        if (isAfterInsert()) {
            for (User recordNew :  (User[]) getRecords()) {
                system.debug('recordNew.Field_Role__c++'+recordNew.Field_Role__c);
                if (recordNew.Field_Role__c != null && lstAcceptableRoles.contains(recordNew.Field_Role__c) &&  recordNew.IsActive) {
                    newUserAssign.add(recordNew.id);
                }
            }
        } else if (isAfterUpdate()) {
            Map<Id,User_Assignment__c> existingUserAssignMap = new Map<Id,User_Assignment__c>();
            for (User recordNew : (User[]) getRecords()) {
                User recordOld = (User) getRecordOld(recordNew.Id, new User());
                system.debug('recordNew.Field_Role__c++'+recordNew.Field_Role__c);
                if (recordNew.Field_Role__c!=null && lstAcceptableRoles.contains(recordNew.Field_Role__c) && recordNew.IsActive  && !recordOld.IsActive ) {
                    userIDs.add(recordNew.id);
                }
            }
            if (!userIDs.isEmpty() && userIDs.size() > 0) {
                for (User_Assignment__c existingUserAssign :erp_UserAssignmentSelector.getUserAssignmentByUserIds(userIDs) ){
                    
                    existingUserAssignMap.put(existingUserAssign.User__c, existingUserAssign);
                }
                for (Id userId : userIDs) {
                    if (!existingUserAssignMap.containsKey(userId)) {
                        newUserAssign.add(userId);
                    }
                }
            }
        }
        if (!newUserAssign.isEmpty() && newUserAssign.size() > 0) {
            createUserAssignments(newUserAssign);
        }
        
    }
}