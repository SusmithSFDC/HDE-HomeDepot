@IsTest
public class erp_DuplicateAssignmentCtrlTest {
    
    @TestSetup
    public static void testSetup() {
        Profile prof = [select id from profile where name = 'HDI Branch Admin'];
        UserRole AISRole = new UserRole(Name = 'Area Installation Specialist');
        insert AISRole;
        
        User userA = new User();
        userA.firstName = 'userA';
        userA.lastName = 'testA';
        userA.profileId = prof.id;
        userA.username = 'testa@testbim.com';
        userA.email = 'testa@testbim.com';
        //userA.Install_Role__c = 'Area Installation Specialist';
        userA.UserRoleId = AISRole.id;
        userA.Alias = 'testerA';
        userA.TimeZoneSidKey = 'America/New_York';
        userA.LocaleSidKey = 'en_US';
        userA.EmailEncodingKey = 'ISO-8859-1';
        userA.LanguageLocaleKey = 'en_US';
        User userB = new User();
        userB.firstName = 'userB';
        userB.lastName = 'testB';
        userB.profileId = prof.id;
        userB.username = 'userb@testbim.com';
        userB.email = 'userb@testbim.com';
        //userB.Install_Role__c = 'Area Installation Specialist';
        userB.UserRoleId = AISRole.id;
        userB.Alias = 'testerB';
        userB.TimeZoneSidKey = 'America/New_York';
        userB.LocaleSidKey = 'en_US';
        userB.EmailEncodingKey = 'ISO-8859-1';
        userB.LanguageLocaleKey = 'en_US';
        insert new List<User>{userA, userB};
            
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
            installBranch.Name = 'Atlanta1';
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
            
            
            List<Product2> products = [Select Id, Name, Family from Product2 where ProductCode = '2'];
            User_Assignment__c userAAssignment = new User_Assignment__c();
            userAAssignment.User__c = userA.Id;
            userAAssignment.unique_name__c = 'User A';
            userAAssignment.name = 'User A';
            
            User_Assignment__c userAssignmentB = new User_Assignment__c();
            userAssignmentB.User__c = userB.Id;
            userAssignmentB.unique_name__c = 'User B';
            userAssignmentB.name = 'User B';
            
            insert new List<User_Assignment__c>{userAAssignment,userAssignmentB};
            User_Additional_Assignment__c additionalAssig = new User_Additional_Assignment__c();
            additionalAssig.User_Assignment__c = userAAssignment.Id;
            additionalAssig.Type__c = 'Store Product';
            additionalAssig.Store__c = store.Id;
            additionalAssig.Product2__c=products[0].id;
            insert additionalAssig;
        }
    }
    
    @IsTest
    public static void duplicateUserAssignmentTest(){
        
        User userB = [Select Id,firstName from User where firstName = 'userB'];
        system.debug('userB >> ' +userB.firstName);
        List<User_Assignment__c> userBAssingment = [Select Id,Name from User_Assignment__c where User__c = :userB.Id];
        System.debug('userBAssingment >>>' +userBAssingment);
        Business_Unit__c businessUnit1 = [Select ID from Business_Unit__c where Code__c ='36' 
                                          and Type__c ='Install Branch' limit 1];
        Store__c availableStore = [Select ID,District_Number__c,Name from Store__c where Store_Code__c = '0121' limit 1];
        List<Product2> products = [Select Id, Name, Family from Product2 where ProductCode = '2'];
        
        List<erp_StoreProduct> storeProductList = new List<erp_StoreProduct>();
        erp_StoreProduct storeProduct = new erp_StoreProduct();
        storeProduct.isChecked = true;
        storeProduct.name = '1';
        storeProduct.stores = new List<erp_StoreProduct.Store>();
        erp_StoreProduct.Store store = new erp_StoreProduct.Store();
        store.id = availableStore.Id;
        store.name = availableStore.name;
        store.isChecked = true;
        store.products = new List<erp_StoreProduct.Product>();	
        erp_StoreProduct.Product product = new erp_StoreProduct.Product();
        product.id = products[0].Id;
        product.name = products[0].name;
        product.isChecked = true;
        store.products.add(product);
        storeProduct.stores.add(store);        
        storeProductList.add(storeProduct);
        
        List<erp_DuplicateAssignmentCtrl.FlowInput> requests = new List<erp_DuplicateAssignmentCtrl.FlowInput>();
        erp_DuplicateAssignmentCtrl.FlowInput request = new erp_DuplicateAssignmentCtrl.FlowInput();
        request.userAssignmentRecordId = userBAssingment[0].Id;
        request.storeProducts = JSON.serialize(storeProductList);
       
        requests.add(request);
        erp_DuplicateAssignmentCtrl.validateDuplicateAssignment(requests);
    }
    
}