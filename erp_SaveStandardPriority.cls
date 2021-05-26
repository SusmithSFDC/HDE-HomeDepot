public class erp_SaveStandardPriority {
	@InvocableMethod(label = 'Save Standard Priority')
    public static void saveStandardPriority(List<FlowInput> requests) {
        FlowInput request = requests[0];
        List<Business_Unit__c> lstRegions = new List<Business_Unit__c>();
        system.debug('request++'+request);
        List<ERP_FlowDuallistboxController.jsonWrapper> lstData = (List<ERP_FlowDuallistboxController.jsonWrapper>) JSON.deserialize(request.regionData, List<ERP_FlowDuallistboxController.jsonWrapper>.class);
        for(ERP_FlowDuallistboxController.jsonWrapper data : lstData){
            Integer Priority = 1;
            for(String region : data.selectedRegions){
                Business_Unit__c bu = new Business_Unit__c();
                bu.id = region;
                bu.Priority__c = Priority;
                Priority++;
                lstRegions.add(bu);
            }
        }
        if(!lstRegions.isEmpty()){
            update lstRegions;
        }
    }
    public class FlowInput{
        @InvocableVariable
        public String regionData;
    }
}