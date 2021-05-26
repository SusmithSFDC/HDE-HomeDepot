@IsTest
private class erp_CreateUserAssignmentTest {

    @testSetup
    public static void testSetup(){                
        Profile prof = [select id from profile where name = 'THD HDE Install Branch Manager'];
        UserRole urole = new UserRole(Name = 'Installation Coordinator');
		insert urole;
        User user = new User();
        user.firstName = 'test1';
        user.lastName = 'test2';
        user.profileId = prof.id;
        user.username = 'test@testbim123.com';
        user.email = 'test@testbim.com';
        //user.Install_Role__c = 'Branch Install Manager';
        user.UserRoleId = urole.id;
        user.Alias = 'tester';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        insert user;
        /*User_Assignment__c userAssignment = new User_Assignment__c();
        userAssignment.User__c = user.Id;
        userAssignment.unique_name__c = 'Create Assignment';
        userAssignment.name = 'Create Assignment';
        insert userAssignment;*/
        User userUpdate = [SELECT Id, firstName FROM User WHERE Field_Role__c = 'Installation Coordinator' LIMIT 1];
        //User userUpdate = [SELECT Id, firstName FROM User WHERE Install_Role__c = 'Branch Install Manager' LIMIT 1];
        userUpdate.firstName = 'Test';
        update userUpdate;
	
    }

    @IsTest static void testCreateUserAssignments(){
		User runAsUser = [SELECT Id FROM User limit 1];
        system.runAs(runAsUser){
            User_Assignment__c userAssignment = new User_Assignment__c();
            userAssignment.User__c = runAsUser.Id;
            userAssignment.unique_name__c = 'Create Assignment';
            userAssignment.name = 'Create Assignment';
            insert userAssignment;
            List<Id> userAssignIds = new List<Id>();
            List<User_Assignment__c> userAsgnList = [SELECT Id, Name, unique_name__c FROM User_Assignment__c];
            for(User_Assignment__c userAssignmnt: userAsgnList){
                userAssignIds.add(userAssignmnt.id);
            }
    
            Test.startTest();
            erp_CreateUserAssignment.createUserAssignments(userAssignIds);
            Test.stopTest();
            //System.assertEquals('Create Assignment', userAsgnList[0].unique_name__c);
		}
    }

}