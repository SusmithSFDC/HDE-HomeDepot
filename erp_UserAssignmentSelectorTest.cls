@IsTest
public class erp_UserAssignmentSelectorTest {
	@testSetup
    public static void testSetup(){
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
        user.UserNo__c = '27551'; 
        insert user; 
        
       	Business_Unit__c installBranch = new Business_Unit__c();
        installBranch.Code__c = '36';
        installBranch.Branch_Code__c = '11';
        installBranch.LOB__c = 'HDE';
        installBranch.Name = 'Atlanta';
        installBranch.Type__c = 'Install Branch';
        insert installBranch;
        
        Store__c store = new Store__c();
        store.Store_Code__c = '1241';
        store.Name = 'test';
        insert store;
        
        Product2 prd = new Product2();
        prd.Name = 'SAMPLE';
        prd.ProductCode = 'test123';
        prd.Family = 'HDIS';
        insert prd;
        
        User_Assignment__c userAssignment = new User_Assignment__c();
        userAssignment.User__c = user.Id;
        userAssignment.unique_name__c = 'Test Assignment';
        userAssignment.name = 'Test Assignment';
        insert userAssignment;
        
        User_Branch_Assignment__c usrBranch = new User_Branch_Assignment__c();
        usrBranch.Business_Unit__c = installBranch.Id;
        usrBranch.User_Assignment__c = userAssignment.Id;
        usrBranch.User__c = user.Id;
        //usrBranch.Type__c = installBranch.Id;
        insert usrBranch;
        
        User_Additional_Assignment__c addAssignment = new User_Additional_Assignment__c();
        addAssignment.User__c = user.id;
        addAssignment.Type__c = 'Store Product';
        addAssignment.Store__c = store.Id;
		addAssignment.Product2__c = prd.Id;
        addAssignment.Previous_User__c = user.Id;
        insert addAssignment;
        
        
    }
    
    @isTest
        public static void testMethod1(){
            Set<Id> sid = new Set<Id>();
            List<User_Assignment__c> lstUserAssignment = [select id from User_Assignment__c];
            sid.add(lstUserAssignment[0].id);
            Test.startTest();
            erp_UserAssignmentSelector.getUserAssignmentByUserIds(sid);
            Test.stopTest();
        }
    
    @isTest
    public static void testMethod2(){
        set<Id> sid1 = new Set<Id>();
        List<User_Branch_Assignment__c> lstBranchAssignment = [select id from User_Branch_Assignment__c];
        sid1.add(lstBranchAssignment[0].id);
        test.startTest();
        erp_UserAssignmentSelector.getUserBranchAssignmentByIds(sid1);
        test.stopTest();
    }
    
    @isTest
    public static void testMethod3(){
        set<Id> sid2 = new Set<Id>();
        List<User_Additional_Assignment__c> lstAdditionalAssgnment = [select id from User_Additional_Assignment__c];
        sid2.add(lstAdditionalAssgnment[0].id);
        test.startTest();
        erp_UserAssignmentSelector.getUserAddnlAssignmentByIds(sid2);
        test.stopTest();
    }
}