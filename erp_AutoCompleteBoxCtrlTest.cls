@isTest
public class erp_AutoCompleteBoxCtrlTest {
    
    @testSetup 
    public static void testSetup() {
        Profile prof = [select id from profile where name = 'THD HDE Install Branch Manager'];
                User user = new User();
        Integer randomNumber = Integer.valueof((Math.random() * 10));
        user.firstName = 'test1';
        user.lastName = 'test2';
        user.profileId = prof.id;
        user.username = 'test@testbim.com'+randomNumber;
        user.email = 'test@testbim.com';        
        user.Alias = 'tester'; 
        user.TimeZoneSidKey = 'America/New_York'; 
        user.LocaleSidKey = 'en_US';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        insert user;
        User_Assignment__c userAssignment = new User_Assignment__c();
        userAssignment.User__c = user.Id;
        userAssignment.unique_name__c = 'Test Assignment';
        userAssignment.name = 'Test Assignment';
        insert userAssignment;
        Business_Unit__c installBranch = new Business_Unit__c();
        installBranch.Code__c = '36';
        installBranch.Branch_Code__c = '11';
        installBranch.LOB__c = 'HDE';
        installBranch.Name = 'Atlanta';
        installBranch.Type__c = 'Install Branch';
        installBranch.Email__c = 'branch-6@example.com';
        insert installBranch;
        User_Branch_Assignment__c userBranchAssignment = new User_Branch_Assignment__c();
        userBranchAssignment.Business_Unit__c = installBranch.id;
        userBranchAssignment.User__c = user.id;
        userBranchAssignment.User_Assignment__c = userAssignment.id;
        insert userBranchAssignment;
    }
    
    @IsTest
    public static void getUserBranchIdTest() {
        List<User_Assignment__c> lstUserAssignment = [select id from User_Assignment__c];
        Test.startTest();
        erp_AutoCompleteBoxCtrl.getUserBranchId(new List<string>{lstUserAssignment[0].id});
        Test.stopTest();
    }
}