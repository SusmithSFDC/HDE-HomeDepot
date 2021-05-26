@isTest
public class ERP_FlowDuallistboxControllerTest {
    
    @testSetup 
    public static void testSetup() {
        Profile prof = [select id from profile where name = 'THD HDE Install Branch Manager'];
        UserRole urole = new UserRole(Name = 'Branch Install Manager');
        insert urole;
        User user = new User();
        Integer randomNumber = Integer.valueof((Math.random() * 10));
        user.firstName = 'test1';
        user.lastName = 'test2';
        user.profileId = prof.id;
        user.username = 'test@testbim.com'+randomNumber;
        user.email = 'test@testbim.com';
        user.UserRoleId = urole.id;
        user.Alias = 'tester'; 
        user.TimeZoneSidKey = 'America/New_York'; 
        user.LocaleSidKey = 'en_US';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        insert user;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() limit 1];       
        System.runAs (thisUser) {
            User_Assignment__c userAssignment = new User_Assignment__c();
            userAssignment.User__c = user.Id;
            userAssignment.unique_name__c = 'Test Assignment';
            userAssignment.name = 'Test Assignment';
            insert userAssignment;
            
            List<Business_Unit__c> lstBusinessUnit = new List<Business_Unit__c>();
            Business_Unit__c bunit = new Business_Unit__c();
            bunit.Name = 'Western';
            bunit.Type__c = 'Install Division';
            bunit.Company__c = 'HDIS';
            insert bunit;
            
            Business_Unit__c bunit1 = new Business_Unit__c();
            bunit1.Name = 'Pacific Central';
            bunit1.Type__c = 'Region';
            bunit1.InstallDivision__c = bunit.Id;   
            bunit1.LOB__c = 'HDIS';
            bunit1.is_SCN_Lead__c = false;
            //insert bunit1;
            lstBusinessUnit.add(bunit1);
            
            Business_Unit__c bunit2 = new Business_Unit__c();
            bunit2.Name = 'Pacific South';
            bunit2.Type__c = 'Region';
            bunit2.InstallDivision__c = bunit.Id;   
            bunit2.LOB__c = 'HDIS';
            bunit2.is_SCN_Lead__c = false;
            //insert bunit1;
			lstBusinessUnit.add(bunit2);
            //lstBusinessUnit.add(bunit1);
            insert lstBusinessUnit;
            
            User_Additional_Assignment__c additionalAssig = new User_Additional_Assignment__c();
            additionalAssig.User_Assignment__c = userAssignment.Id;
            additionalAssig.Type__c = 'Region Priority';
            additionalAssig.region__c = lstBusinessUnit[0].id;
            additionalAssig.division__c = bunit.id;
            insert additionalAssig;  
        }
        
    }
    
    @isTest
    static void testMethod1(){
        String divisionIds = '';
        List<erp_CheckboxGroupOptions> lstDivisions = new List<erp_CheckboxGroupOptions>();
        List<User_Assignment__c> lstUserAssignment = [select id from User_Assignment__c limit 1];
        for(Business_Unit__c bu : [select id,name from Business_Unit__c where type__c='Install Division']){
            system.debug('bu++'+bu);
            erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
            option.label = bu.name;
            option.value = bu.id;
            lstDivisions.add(option);
        }
        divisionIds = JSON.serialize(lstDivisions);
        system.debug('divisionIds++'+divisionIds);
        Test.startTest();        
        ERP_FlowDuallistboxController.getDivisionRegionData(divisionIds,lstUserAssignment[0].Id);
        Test.stopTest();
    }
    @isTest
    static void testMethod2(){
        String divisionIds = '';        
        List<User_Assignment__c> lstUserAssignment = [select id from User_Assignment__c limit 1];
        Test.startTest();        
        ERP_FlowDuallistboxController.getStandardDivisionRegionData(lstUserAssignment[0].Id);
        Test.stopTest();
    }
}