@isTest
public class erp_SaveUserOCAssignmentTest {
    
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
            TestUtility.initializeTestData(); 
            Store__c store = [Select ID,District_Number__c from Store__c where Store_Code__c = '0121' limit 1];
            store.District_Number__c = 1;
            update store;
            Business_Unit__c salesBranch = [Select ID, Install_Branch__c  from Business_Unit__c 
                                            where Code__c ='36' and Type__c ='Branch' limit 1];
            Business_Unit__c installBranch = new Business_Unit__c();
            installBranch.Code__c = '36';
            installBranch.Branch_Code__c = '11';
            installBranch.LOB__c = 'HDE';
            installBranch.Name = 'Atlanta';
            installBranch.Type__c = 'Install Branch';
            installBranch.Email__c = 'branch-6@example.com';
            installBranch.Parent__c = salesBranch.id;
            insert installBranch;
            
            Business_Unit__c bu = new Business_Unit__c();
            bu.Name = 'Pacific South';
            bu.Type__c = 'Install Division';
            bu.LOB__c = 'HDIS';
            bu.is_SCN_Lead__c = false;
            
            Insert bu;
            
            Business_Unit__c bunit = new Business_Unit__c();
            bunit.Name = 'Pacific South';
            bunit.Type__c = 'Region';
            bunit.InstallDivision__c = bu.Id;   
            bunit.LOB__c = 'HDIS';
            bunit.is_SCN_Lead__c = false;
            
            insert bunit;            
            salesBranch.Install_Branch__c = installBranch.id;
            update salesBranch;
            
            Store_Business_Unit__c storebunit = new Store_Business_Unit__c();
            storebunit.Branch__c = salesBranch.id;
            storebunit.Store__c = store.id;
            insert storebunit;
            //Created product to test getSelectedTask
            Product2 product = new Product2();
            product.IsActive = TRUE;
            product.Name = 'Cabinet Makeover';
            product.Family='HDI';
            product.ProductCode ='2';
            insert product;            
            //Created user assignment record
            User_Assignment__c userAssignment = new User_Assignment__c();
            userAssignment.User__c = user.Id;
            userAssignment.unique_name__c = 'Test Assignment';
            userAssignment.name = 'Test Assignment';
            insert userAssignment;   
            //Created Additional assignment record
            User_Additional_Assignment__c additionalAssig = new User_Additional_Assignment__c();
            additionalAssig.User_Assignment__c = userAssignment.Id;
            additionalAssig.Type__c = 'Store Product';
            additionalAssig.Store__c = store.Id;
            additionalAssig.Product2__c=product.id;
            insert additionalAssig;  
            User_Additional_Assignment__c userAdd = new User_Additional_Assignment__c();
            userAdd.Type__c = 'Task';
            userAdd.Task__c = 'Sales Recast Completed';
            userAdd.Product2__c = product.Id;
            userAdd.User_Assignment__c = userAssignment.Id;
            userAdd.Product2__c=product.id;
            insert userAdd;
        }
    }
    
    @isTest
    public static void testMethod1(){
        List<erp_SaveUserOCAssignment.FlowInput> lstFlow = new List<erp_SaveUserOCAssignment.FlowInput>();
        String divisionId ='';
        List<String> lstRegions = new List<String>();
        List<String> lstProducts = new List<String>();
        List<String> lstTasks = new List<String>();
        List<String> lstVendors = new List<String>();
        List<String> lstDivisions = new List<String>();
		List<String> lstBranches = new List<String>();
        List<ERP_FlowDuallistboxController.jsonWrapper> lstWrapper = new List<ERP_FlowDuallistboxController.jsonWrapper>();
        //List<erp_CheckboxGroupOptions> lstErpTask = new List<erp_CheckboxGroupOptions>();
        erp_CheckboxGroupOptions optTask = new erp_CheckboxGroupOptions();
        optTask.label = 'Task1';
        optTask.value = 'Task1';        
        lstTasks.add(JSON.serialize(optTask));
        erp_CheckboxGroupOptions optVendor = new erp_CheckboxGroupOptions();
        optVendor.label = 'Vendor1';
        optVendor.value = 'Vendor1';        
        lstVendors.add(JSON.serialize(optVendor));
        List<User_Assignment__c> lstUserAssignment = [select id from User_Assignment__c];
        for(Product2 prd : [select id from Product2]){
            lstProducts.add(prd.id);
        }
        
        
        for(Business_Unit__c bunit : [select id from Business_Unit__c where Type__c = 'Region']){
            lstRegions.add(bunit.id);
        }
        
        
        for(Business_Unit__c bunit : [select id,name from Business_Unit__c where Type__c = 'Install Division']){
            divisionId = bunit.Id;
            erp_CheckboxGroupOptions optDivision = new erp_CheckboxGroupOptions();
            optDivision.label = bunit.name;
            optDivision.value = bunit.id;        
            lstDivisions.add(JSON.serialize(optDivision));
        }
        ERP_FlowDuallistboxController.jsonWrapper js = new ERP_FlowDuallistboxController.jsonWrapper();
        js.selectedRegions = lstRegions;
        js.divisionId = divisionId;
        lstWrapper.add(js);
        for(Business_Unit__c bunit : [select id,name from Business_Unit__c where Type__c = 'Install Branch']){
            erp_CheckboxGroupOptions optBranch = new erp_CheckboxGroupOptions();
            optBranch.label = bunit.Name;
            optBranch.value = bunit.Id;        
            lstBranches.add(JSON.serialize(optBranch));
        }
        erp_SaveUserOCAssignment.FlowInput flowInp = new erp_SaveUserOCAssignment.FlowInput();
        flowInp.userAssignmentRecordId = lstUserAssignment[0].Id;
        flowInp.selectedDivision = lstDivisions;
        flowInp.selectedRegions = JSON.serialize(lstWrapper);
        flowInp.selectedBranches = lstBranches;
        flowInp.selectedVendors = lstVendors;
        flowInp.selectedTasks = lstTasks;
        flowInp.selectedProductIds = lstProducts;
        lstFlow.add(flowInp);
        Test.startTest();
        erp_SaveUserOCAssignment.saveOCUserAssignment(lstFlow);
        Test.stopTest();
        
    }
}