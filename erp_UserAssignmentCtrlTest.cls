@isTest
public class erp_UserAssignmentCtrlTest {

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
    
    @IsTest
    public static void testGetStoreProductList() {
        Business_Unit__c businessUnit1 = [Select ID, Install_Branch__c  from Business_Unit__c 
                                            where Code__c ='36' and Type__c ='Branch' limit 1];

        List<String> productIds = new List<String>();
        for(Product2 product : [Select Id from Product2 where ProductCode = '2']){
            productIds.add(product.Id);
        }
  
        List<User_Assignment__c> lstUserAssignment = [select id from User_Assignment__c];
        
        Test.startTest();
        //Added userassignmentId in parameter
        List<erp_StoreProduct> storeProductList = erp_UserAssignmentCtrl.getStoreProductList(businessUnit1.Id, productIds,lstUserAssignment[0].Id);
        Test.stopTest();
        system.debug('storeProductList -->' +storeProductList);
        System.assert(storeProductList.size() > 0, 'Store Product List should not be empty');
    }
    
    @IsTest
    public static void testSaveUserAssignment(){
        Business_Unit__c businessUnit1 = [Select ID from Business_Unit__c where Code__c ='36' 
                                          and Type__c ='Install Branch' limit 1];
        List<User_Assignment__c> lstUserAssignment = [select id from User_Assignment__c];
        List<String> productIds = new List<String>();
        for(Product2 product : [Select Id, Name, Family from Product2 where ProductCode = '2']){
            productIds.add(product.Id);
        }
        //Added userassignmentId in parameter
        List<erp_StoreProduct> storeProductList = erp_UserAssignmentCtrl.getStoreProductList(businessUnit1.Id, productIds,lstUserAssignment[0].Id);
        for(erp_StoreProduct storeProduct : storeProductList){
            for(erp_StoreProduct.Store store : storeProduct.stores){
                store.isChecked = true;
                for(erp_StoreProduct.Product product : store.products){
                    product.isChecked = true;
                }
            }
        }
        
        
        User_Assignment__c userassignment = [SELECT Id, User__c FROM User_Assignment__c limit 1];
        /*erp_TaskProducts taskProduct = new erp_TaskProducts();
        taskProduct.taskName = 'test';
        taskProduct.isChecked = true;*/
        
        erp_UserAssignmentCtrl.FlowInput request = new erp_UserAssignmentCtrl.FlowInput();
        request.userAssignmentRecordId = userassignment.id;
        request.branchId = businessUnit1.Id;
        request.productIds = productIds;
        //request.selectedTaskProducts = string.valueOf('taskProduct');
            
        
        //Serialising the productlist
        request.storeProducts = JSON.serialize(storeProductList);
        request.selectedTaskProducts = erp_TaskProductsCtrl.getTaskProducts(productIds, lstUserAssignment[0].Id);
        request.reassignOpenTask = true;
        
        
        //Added selectedtask to request
        request.selectedTasks = new List<String>{'Task1','Task2'};
            
        List<erp_UserAssignmentCtrl.FlowInput> requests = new List<erp_UserAssignmentCtrl.FlowInput>();
        requests.add(request);
        Test.startTest();
        erp_UserAssignmentCtrl.saveUserAssignment(requests);
        Test.stopTest();
        User_Branch_Assignment__c branchAssignment = [SELECT Id, User_Assignment__c FROM User_Branch_Assignment__c limit 1];
        System.assertEquals(userassignment.Id, branchAssignment.User_Assignment__c, 'User must be assigned to home branch');
           
    }
    
    @IsTest
    public static void duplicationUserAssignmentTest(){
        Business_Unit__c businessUnit1 = [Select ID from Business_Unit__c where Code__c ='36' 
                                          and Type__c ='Install Branch' limit 1];
        List<User_Assignment__c> lstUserAssignment = [select id from User_Assignment__c];
        List<String> productIds = new List<String>();
        for(Product2 product : [Select Id from Product2 where ProductCode = '2']){
            productIds.add(product.Id);
        }
        List<erp_StoreProduct> storeProductList = erp_UserAssignmentCtrl.getStoreProductList(businessUnit1.Id, productIds, lstUserAssignment[0].Id);
        for(erp_StoreProduct storeProduct : storeProductList){
            for(erp_StoreProduct.Store store : storeProduct.stores){
                store.isChecked = true;
                for(erp_StoreProduct.Product product : store.products){
                    product.isChecked = true;
                }
            }
        }
        List<User_Assignment__c> userassignment = [SELECT Id, User__c FROM User_Assignment__c limit 2];
        erp_UserAssignmentCtrl.FlowInput request = new erp_UserAssignmentCtrl.FlowInput();
        request.userAssignmentRecordId = userassignment[0].id;
        request.branchId = businessUnit1.Id;
        request.productIds = productIds;
        request.storeProducts = JSON.serialize(storeProductList);
        List<erp_UserAssignmentCtrl.FlowInput> requests = new List<erp_UserAssignmentCtrl.FlowInput>();
        requests.add(request);
        
        erp_UserAssignmentCtrl.saveUserAssignment(requests);
 
        Test.startTest();
        
        erp_UserAssignmentCtrl.FlowInput request2 = new erp_UserAssignmentCtrl.FlowInput();
        request2.userAssignmentRecordId = userassignment[0].id;
        request2.branchId = businessUnit1.Id;
        request2.productIds = productIds;
        request2.storeProducts = JSON.serialize(storeProductList);
        List<erp_UserAssignmentCtrl.FlowInput> requests2 = new List<erp_UserAssignmentCtrl.FlowInput>();
        requests2.add(request2);
        
        erp_UserAssignmentCtrl.saveUserAssignment(requests2); 
        Test.stopTest();
        List<User_Additional_Assignment__c> lsUserAdd = [SELECT User__c, Previous_User__c 
                                                         FROM User_Additional_Assignment__c];
        //System.assertEquals(1, lsUserAdd.size());
        System.assertEquals(userassignment[0].User__c, lsUserAdd[0].User__c);
        //System.assertEquals(userassignment[1].User__c, lsUserAdd[0].Previous_User__c);
    
    }
}