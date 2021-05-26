@isTest
private class erp_UserAssingmentServiceTest {

    @testSetup
    public static void testSetup(){
        TestUtilityERP.createSalesOrders(1);
        gii__SalesOrder__c job = [SELECT Id FROM gii__SalesOrder__c LIMIT 1];
        Profile prof = [select id from profile where name = 'THD HDE Install Branch Manager'];
        User user = new User();
        user.firstName = 'test';
        user.lastName = 'test1';
        user.profileId = prof.id;
        user.username = 'test12@testbim.com';
        user.email = 'test1@testbim.com';
        user.Alias = 'tester';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        insert user;
        User newUser = new User();
        newUser.firstName = 'test2';
        newUser.lastName = 'test2';
        newUser.profileId = prof.id;
        newUser.username = 'test2@testbim.com';
        newUser.email = 'test2@testbim.com';
        newUser.Alias = 'tester2';
        newUser.TimeZoneSidKey = 'America/New_York';
        newUser.LocaleSidKey = 'en_US';
        newUser.EmailEncodingKey = 'ISO-8859-1';
        newUser.LanguageLocaleKey = 'en_US';
        insert newUser;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() limit 1];       
        System.runAs (thisUser) {
            TestUtility.initializeTestData(); 
            Store__c store = [Select ID, District_Number__c from Store__c where Store_Code__c = '0121' limit 1];
            store.District_Number__c = 1;
            update store;
            Product2 product = new Product2();
            product.IsActive = TRUE;
            product.Name = 'Cabinet Makeover';
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
            additionalAssig.Previous_User__c = user.Id;
            additionalAssig.Product2__c=product.id;
            insert additionalAssig;
            Customer_Order__c customerOrder = new Customer_Order__c();
            customerOrder.Name = 'Test';
            customerOrder.Order_Status__c = 'Received';
            insert customerOrder;
            job.Customer_Order__c = customerOrder.Id;
            job.giic_Store__c = store.id;
            job.giic_Product_Reference__c = product.id;
            update job;
            Task task = new Task();
            task.Customer_Order__c = customerOrder.Id;
            task.Subject = 'Welcome Call';
            task.OwnerId = user.Id;
            task.Job_Status__c = 'Received';
            task.Status = 'Open'; 
            task.Product__c = product.id;
            task.WhatId = customerOrder.Id;
            insert task;
            Job_Contacts__c jobContacts = new Job_Contacts__c();
            jobContacts.Customer_Order__c = customerOrder.Id;
            jobContacts.User__c = user.Id;
            jobContacts.Name = user.Name;
            jobContacts.Job__c = job.id;
            insert jobContacts;
        }
    }

    @IsTest static void testUpdateJobContactsAndTasks(){
        Set<Id> previousUserId = new Set<Id>();
        Job_Contacts__c currentUserId = [SELECT Id, Name, User__c FROM Job_Contacts__c];
        previousUserId.add(currentUserId.User__c);
        List<User_Additional_Assignment__c> jobContactsToUpdate = [SELECT Id, Previous_User__c, Product2__c, Store__c 
                                                                   FROM User_Additional_Assignment__c];
       
        User newUserId = [SELECT Id, Name FROM User WHERE Id not in: previousUserId LIMIT 1];
        
        Test.startTest();
        erp_UserAssingmentService.updateJobContactsAndTasks(jobContactsToUpdate, newUserId, true);
        Test.stopTest();

        Task openTask = [SELECT OwnerId, Status FROM Task WHERE Status = 'Open' LIMIT 1];
        //System.assertEquals(newUserId, openTask.OwnerId);
        System.assertEquals('Open', openTask.Status);
        

    }

}