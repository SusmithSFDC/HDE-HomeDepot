/**
* Created by AXP8376 on 12/7/2020.
*/

public with sharing class erp_UserAssignmentSelector {
    public static List<User_Assignment__c> getUserAssignmentByUserIds(Set<Id> idSet){
        if (idSet == null || idSet.isEmpty()) return new List<User_Assignment__c>();
        
        return [SELECT id,User__c from User_Assignment__c where User__c in:(idSet)];
        
    }
    
    public static List<User_Branch_Assignment__c> getUserBranchAssignmentByIds(Set<Id> idSet){
        if (idSet == null || idSet.isEmpty()) return new List<User_Branch_Assignment__c>();
        
        return [SELECT Id, Business_Unit__c, Business_Unit__r.Branch_Code__c,
                User__r.UserNo__c, Type__c,Business_Unit__r.LOB__c
                FROM User_Branch_Assignment__c
                WHERE User_Assignment__c  in :(idSet)];
        
    }
    public static List<User_Additional_Assignment__c> getUserAddnlAssignmentByIds(Set<Id> idSet) {
        if (idSet == null || idSet.isEmpty()) return new List<User_Additional_Assignment__c>();
        return [
            SELECT Id, User__c, Type__c,Store__c, Store__r.Store_Code__c,
                    Product2__c, Product2__r.Name, Product2__r.ProductCode,
                    Product2__r.Family, Previous_User__r.UserNo__c
            FROM User_Additional_Assignment__c
            WHERE User_Assignment__c in :(idSet)
        ];
    }
}