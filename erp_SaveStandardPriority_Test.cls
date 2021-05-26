@isTest
public class erp_SaveStandardPriority_Test {
    @testSetup
    public static void testSaveMethod(){
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
    }
    
    @isTest
    public static void testMethod1(){
        List<erp_SaveStandardPriority.FlowInput> lstFlow = new List<erp_SaveStandardPriority.FlowInput>();
        List<ERP_FlowDuallistboxController.jsonWrapper> lstWrapper = new List<ERP_FlowDuallistboxController.jsonWrapper>();
        List<String> lstRegions = new List<String>();
        for(Business_Unit__c bunit : [select id from Business_Unit__c]){
            lstRegions.add(bunit.id);
        }
        ERP_FlowDuallistboxController.jsonWrapper js = new ERP_FlowDuallistboxController.jsonWrapper();
        js.selectedRegions = lstRegions;
        lstWrapper.add(js);
        erp_SaveStandardPriority.FlowInput flowInp = new erp_SaveStandardPriority.FlowInput();
        flowInp.regionData = JSON.serialize(lstWrapper);
        lstFlow.add(flowInp);
        Test.startTest();
        erp_SaveStandardPriority.saveStandardPriority(lstFlow);
        Test.stopTest();
    }
}