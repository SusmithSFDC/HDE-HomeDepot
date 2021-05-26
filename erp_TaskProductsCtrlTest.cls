@IsTest
private class erp_TaskProductsCtrlTest {

    @testSetup
    public static void testSetup() {
        Profile prof = [select id from profile where name = 'THD HDE Install Branch Manager'];          
		UserRole urole = new UserRole(Name = 'Installation Coordinator');
		insert urole;
        User user = new User();
        user.firstName = 'test1';
        user.lastName = 'test2';
        user.profileId = prof.id;
        user.username = 'test123@testbim.com';
        user.email = 'test@testbim.com';
        //user.Install_Role__c = 'Install Coordinator';
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
            userAssignment.unique_name__c = 'Test Task Products';
            userAssignment.name = 'Test Task Products';
            insert userAssignment;
            List<Product2> listOfProducts = new List<Product2>();
            Product2 product1 = new Product2();
            product1.IsActive = TRUE;
            product1.Name = 'Cabinet Makeover';
            product1.Family='HDI';
            listOfProducts.add(product1);
            Product2 product2 = new Product2();
            product2.IsActive = TRUE;
            product2.Name = 'Entry Doors';
            product2.Family='HDE';
            listOfProducts.add(product2);
            Product2 product3 = new Product2();
            product3.IsActive = TRUE;
            product3.Name = 'Storm Protection';
            product3.Family='HDE';
            listOfProducts.add(product3);
            Product2 product4 = new Product2();
            product4.IsActive = TRUE;
            product4.Name = 'Windows';
            product4.Family='HDE';
            listOfProducts.add(product4);
            insert listOfProducts;
            User_Additional_Assignment__c userAdd = new User_Additional_Assignment__c();
            userAdd.Type__c = 'Task';
            userAdd.Task__c = 'Sales Recast Completed';
            userAdd.Product2__c = product1.Id;
            userAdd.User_Assignment__c = userAssignment.Id;
            insert userAdd;
        }
    }



    @IsTest static void testGetTaskProducts(){
        List<String> productIds = new List<String>();
        List<Product2> products = [SELECT Id, Name, Family FROM Product2];
        for(Product2 product: products){
            productIds.add(product.Id);
        }

        User_Assignment__c userAssgnId = [SELECT Id, Name, User_Role__c FROM User_Assignment__c LIMIT 1];
        String userAssignmentId = (String) userAssgnId.Id;

        Test.startTest();
        erp_TaskProductsCtrl.getTaskProducts(productIds, userAssignmentId);
        Test.stopTest();
        
        User_Additional_Assignment__c addAssignment = [Select Type__c, Task__c From  User_Additional_Assignment__c LIMIT 1];
      
        System.assert(addAssignment != null);  
        //System.assertEquals('Installation Coordinator', userAssgnId.User_Role__c);
        System.assertEquals('Task', addAssignment.Type__c);
        System.assertEquals('Sales Recast Completed', addAssignment.Task__c);

    }

}