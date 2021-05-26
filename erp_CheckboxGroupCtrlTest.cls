@isTest
    public class erp_CheckboxGroupCtrlTest {
    
    @testSetup 
    public static void testSetup() {
        list<Product2> productList = new list<Product2>();
        Product2 product1 = new Product2();
        product1.IsActive = TRUE;
        product1.Name = 'Cabinet Makeover';
        product1.ProductCode = '17';
        product1.Family='HDI';
        product1.Service_Program__c = 'SF&I Cabinet Makeover';
        productList.add(product1);
        Product2 product2 = new Product2();
        product2.IsActive = TRUE; 
        product2.Name = 'Entry Doors';
        product2.ProductCode = '17';
        product2.Family='HDI';
        product2.Service_Program__c = 'SF&I Doors';
        productList.add(product2);
        Product2 product3 = new Product2();
        product3.IsActive = TRUE;
        product3.Name = 'Storm Protection';
        product3.ProductCode = '17';
        product3.Family='HDI';
        product3.Service_Program__c = 'SF&I Storm Shelter';
        productList.add(product3);
        Product2 product4 = new Product2();
        product4.IsActive = TRUE;
        product4.Name = 'Windows';
        product4.ProductCode = '17';
        product4.Family='HDI';
        product4.Service_Program__c = 'SF&I Windows - RSW';
        productList.add(product4);
        insert productList;
        
        list<Business_Unit__c> lstBusinessUnit = new list<Business_Unit__c>();
        Business_Unit__c bunit = new Business_Unit__c();
        bunit.Name = 'Test BU';
        bunit.Type__c = 'Install Branch';
        bunit.Branch_Code__c = '11';
        bunit.LOB__c = 'HDIS';
        lstBusinessUnit.add(bunit);
        Business_Unit__c bunit1 = new Business_Unit__c();
        bunit1.Name = 'Western';
        bunit1.Type__c = 'Install Division';
        bunit1.LOB__c = 'HDIS';
        lstBusinessUnit.add(bunit1);
        insert lstBusinessUnit;
        
        Account acc = new Account();
        acc.Name = 'AirMaster';
        acc.AccountNumber = '40';
        acc.Active__c = true;
        acc.Line_Of_Business__c = 'HDE';
        insert acc;
    }
    
    @IsTest
    public static void testGetCheckboxGroupOptions() {
        List<erp_CheckboxGroupCtrl.Results> respons = erp_CheckboxGroupCtrl.getCheckboxGroupOptions(new List<String>{'Product'});
        System.assert(respons!=null && respons.size()>0, 'Response is empty');
        erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
        option.label = 'Cabinet Makeover';
        option.value = 'Cabinet Makeover';
        System.assertEquals('Cabinet Makeover', option.value);
    }
        
    @IsTest
    public static void testGetCheckboxGroupOptionsTask() {
        List<erp_CheckboxGroupCtrl.Results> respons = erp_CheckboxGroupCtrl.getCheckboxGroupOptions(new List<String>{'TASK'});
        System.debug('Response:::'+respons);
        System.assert(respons!=null && respons.size()>0, 'Response is empty');
        erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
        option.label = 'Cabinet Makeover';
        option.value = 'Cabinet Makeover';
        System.assertEquals('Cabinet Makeover', option.value);
    }
        
    @IsTest
    public static void testGetCheckboxGroupOptionsBranch() {
        List<erp_CheckboxGroupCtrl.Results> respons = erp_CheckboxGroupCtrl.getCheckboxGroupOptions(new List<String>{'BRANCH'});
        system.debug('respnse:::'+respons);
        System.assert(respons!=null && respons.size()>0, 'Response is empty');
        erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
        option.label = 'Test BU';
        option.value = 'Test BU';
        System.assertEquals('Test BU', option.value);
    }
        
    @IsTest
        public static void testGetCheckboxGroupOptionsInstallDivision(){
            List<erp_CheckboxGroupCtrl.Results> respons = erp_CheckboxGroupCtrl.getCheckboxGroupOptions(new List<String>{'INSTALL DIVISION'});
            System.assert(respons!=null && respons.size()>0, 'Response is empty');
            erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
            option.label = 'Western';
            option.value = 'Western';
            System.assertEquals('Western', option.label);
        }
        
	@IsTest
    public static void testGetCheckboxGroupOptionsVendor(){
            List<erp_CheckboxGroupCtrl.Results> respons = erp_CheckboxGroupCtrl.getCheckboxGroupOptions(new List<String>{'VENDOR'});
            System.assert(respons!=null && respons.size()>0, 'Response is empty');
            erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
            option.label = 'AirMaster';
            option.value = 'AirMaster';
            System.assertEquals('AirMaster', option.label);
        }    
        
     @IsTest
        public static void testGetCheckboxGroupOptionsOCTask(){
            List<erp_CheckboxGroupCtrl.Results> respons = erp_CheckboxGroupCtrl.getCheckboxGroupOptions(new List<String>{'OCTASK'});
            System.assert(respons!=null && respons.size()>0, 'Response is empty');
            erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
            option.label = 'Vendor Order Confirmed';
            option.value = 'Vendor Order Confirmed';
            System.assertEquals('Vendor Order Confirmed', option.label);
        }
}