public class erp_InsertFutureRecord {

    @future
    public static void insertUser() {
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
    }
}