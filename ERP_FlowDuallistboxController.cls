public class ERP_FlowDuallistboxController {
    /*@InvocableMethod(label = 'Available Options Duallist')    
    public static List<dataWrapper> getDuallistData(List<FlowInput> input){
        FlowInput request = input[0];
        system.debug('request++'+request);
        system.debug('request.ids++'+request.ids);
        
        List<dataWrapper> lstWrapper = new List<dataWrapper>();
        dataWrapper dw = new dataWrapper();
        dw.options = new List<String>();
        List<Business_Unit__c> lstBusinessUnit = new List<Business_Unit__c>();
        if(request.type != null && string.isNotBlank(request.type)){
            if(request.ids != null && !request.ids.isEmpty() ){//&& request.ids[0] != 'none'
                set<string> setIds = new set<string>();
                system.debug('request.ids[0]++'+request.ids[0].label);
                for(erp_CheckboxGroupOptions erp : request.ids){
                    setIds.add(erp.value);
                }
                if(request.type == 'Region'){
                    lstBusinessUnit = [SELECT id, Name FROM Business_Unit__c WHERE Type__c =: request.type AND InstallDivision__c in: setIds AND is_SCN_Lead__c = false];//   
                }                	
            }
            else{
                lstBusinessUnit = [SELECT id, Name FROM Business_Unit__c WHERE Type__c =: request.type AND LOB__c = 'HDIS' AND is_SCN_Lead__c = false];
            }
            
        }
        //for (UserAssignment__mdt ua : [SELECT MasterLabel, Value__c, Type__c FROM UserAssignment__mdt where Type__c=:lstType[0]]) {
        for(Business_Unit__c bu : lstBusinessUnit){
            erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
            option.label = bu.Name;
            option.value = bu.id;            
            dw.options.add(JSON.serialize(option));
        }
        lstWrapper.add(dw);
        system.debug('lstWrapper++'+lstWrapper);
        system.debug('lstWrapper2++'+JSON.serialize(lstWrapper) );
        return lstWrapper;
    }
    
    @AuraEnabled
    public static List<erp_CheckboxGroupOptions> getPicklistValues(String type,String parentId){
        List<erp_CheckboxGroupOptions> lstOptions = new List<erp_CheckboxGroupOptions>();
        for(Business_Unit__c bu : [SELECT id, Name FROM Business_Unit__c WHERE Type__c =: type AND InstallDivision__c = :parentId AND is_SCN_Lead__c = false]){
            erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
            option.label = bu.Name;
            option.value = bu.id;            
            lstOptions.add(option);
        }
        return lstOptions;
    }
    */
    @AuraEnabled(cacheable=true)
    public static List<jsonWrapper> getDivisionRegionData(String lstDivisions,String userAssignmentRecordId){
        system.debug('lstDivisions++'+lstDivisions);
        system.debug('userAssignmentRecordId++'+userAssignmentRecordId);
        List<erp_CheckboxGroupOptions> lstDiv = (List<erp_CheckboxGroupOptions>)JSON.deserialize(lstDivisions, List<erp_CheckboxGroupOptions>.class);
        system.debug('lstDiv++'+lstDiv);
        list<string> lstDivisionIds = new list<string>(); 
        map<String,List<erp_CheckboxGroupOptions>> mapDivisionRegions = new map<string,List<erp_CheckboxGroupOptions>>();
        map<String,List<string>> mapDivisionSelectedRegions = new map<string,List<string>>();
        map<String,String> mapDivisionIdName = new map<string,String>();
        List<jsonWrapper> lstData = new List<jsonWrapper>();
        for(erp_CheckboxGroupOptions erp : lstDiv){
            lstDivisionIds.add(erp.value);
        }
        for(Business_Unit__c bu : [SELECT id, Name,InstallDivision__c,InstallDivision__r.name FROM Business_Unit__c WHERE Type__c = 'Region' AND LOB__c = 'HDIS'  AND InstallDivision__c in :lstDivisionIds AND is_SCN_Lead__c = false]){
            if(mapDivisionRegions.isEmpty() || !mapDivisionRegions.containsKey(bu.InstallDivision__c)){
                erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
                option.label = bu.Name;
                option.value = bu.id;  
                mapDivisionRegions.put(bu.InstallDivision__c, new List<erp_CheckboxGroupOptions>{option});
                mapDivisionIdName.put(bu.InstallDivision__c,bu.InstallDivision__r.name);
                mapDivisionSelectedRegions.put(bu.InstallDivision__c, new List<string>{bu.id});
            }
            else{
                erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
                option.label = bu.Name;
                option.value = bu.id;  
                mapDivisionRegions.get(bu.InstallDivision__c).add(option);
                mapDivisionSelectedRegions.get(bu.InstallDivision__c).add(bu.id);                                                    
            }
        }
        
        system.debug('mapDivisionRegions++'+mapDivisionRegions);
        system.debug('mapDivisionSelectedRegions++'+mapDivisionSelectedRegions);
        for(string division : mapDivisionRegions.keySet()){
            system.debug('division+'+division);
            jsonWrapper jsw = new jsonWrapper();
            jsw.divisionName = mapDivisionIdName.get(division);                
            jsw.availableRegions = mapDivisionRegions.get(division);
            if(!mapDivisionSelectedRegions.isEmpty() && mapDivisionSelectedRegions.containsKey(division)){
                jsw.selectedRegions = mapDivisionSelectedRegions.get(division);
            }
            else
            	jsw.selectedRegions = new List<String>();
            jsw.divisionId = division;
            lstData.add(jsw);
        }
                 
        system.debug('lstData++'+lstData);
        return lstData;
    }            
    
    @AuraEnabled(cacheable=true)
    public static List<jsonWrapper> getStandardDivisionRegionData(String userAssignmentRecordId){
                
        list<string> lstDivisionIds = new list<string>(); 
        list<string> lstRegionsIds = new list<string>(); 
        List<erp_CheckboxGroupOptions> lstDivisions = new List<erp_CheckboxGroupOptions>();
        map<String,List<erp_CheckboxGroupOptions>> mapDivisionRegions = new map<string,List<erp_CheckboxGroupOptions>>();        
        map<String,List<string>> mapDivisionSelectedRegions = new map<string,List<string>>();
        map<String,String> mapDivisionIdName = new map<string,String>();
        List<jsonWrapper> lstData = new List<jsonWrapper>();
        for(Business_Unit__c divisions : [SELECT id, Name,InstallDivision__c,InstallDivision__r.name FROM Business_Unit__c WHERE Type__c = 'Install Division' AND Company__c = 'HDIS']){
            lstDivisionIds.add(divisions.id);
            erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
            option.label = divisions.Name;
            option.value = divisions.id;
            lstDivisions.add(option);
        }
        for(Business_Unit__c bu : [SELECT id, Name,InstallDivision__c,InstallDivision__r.name FROM Business_Unit__c WHERE Type__c = 'Region' AND LOB__c = 'HDIS'  AND InstallDivision__c in :lstDivisionIds AND is_SCN_Lead__c = false order by Priority__c]){
            if(mapDivisionRegions.isEmpty() || !mapDivisionRegions.containsKey(bu.InstallDivision__c)){
                erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
                option.label = bu.Name;
                option.value = bu.id;  
                mapDivisionRegions.put(bu.InstallDivision__c, new List<erp_CheckboxGroupOptions>{option});
                mapDivisionIdName.put(bu.InstallDivision__c,bu.InstallDivision__r.name);
                mapDivisionSelectedRegions.put(bu.InstallDivision__c, new List<string>{bu.id});
            }
            else{
                erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
                option.label = bu.Name;
                option.value = bu.id;  
                mapDivisionRegions.get(bu.InstallDivision__c).add(option);
                mapDivisionSelectedRegions.get(bu.InstallDivision__c).add(bu.id);
            }
            //lstRegionsIds.add(bu.id);
        }
        
        system.debug('mapDivisionRegions++'+mapDivisionRegions);
        system.debug('mapDivisionSelectedRegions++'+mapDivisionSelectedRegions);
        for(string division : mapDivisionRegions.keySet()){
            system.debug('division+'+division);
            jsonWrapper jsw = new jsonWrapper();
            jsw.divisionName = mapDivisionIdName.get(division);                
            jsw.availableRegions = mapDivisionRegions.get(division);
            if(!mapDivisionSelectedRegions.isEmpty() && mapDivisionSelectedRegions.containsKey(division)){
                jsw.selectedRegions = mapDivisionSelectedRegions.get(division);
            }
            else
            	jsw.selectedRegions = new List<String>();
            //jsw.selectedRegions = lstRegionsIds;
            jsw.divisionId = division;
            jsw.availableDivisions = lstDivisions;
            lstData.add(jsw);
        }
                 
        system.debug('lstData++'+lstData);
        return lstData;
    }
    
    public class dataWrapper{
        @InvocableVariable
        public List<String> options;
        //public List<erp_CheckboxGroupOptions> options;
    }
    public class FlowInput{ 
        @InvocableVariable
        public String type;
        @InvocableVariable
        public List<erp_CheckboxGroupOptions> ids;        
    }
    public class jsonWrapper{
        @AuraEnabled public string divisionName;
        @AuraEnabled public Id divisionId;
        @AuraEnabled public List<erp_CheckboxGroupOptions> availableRegions;
        @AuraEnabled public List<String> selectedRegions;
        @AuraEnabled public List<erp_CheckboxGroupOptions> availableDivisions;
        public jsonWrapper(){
            availableRegions = new List<erp_CheckboxGroupOptions>();
            //selectedRegions = new List<String>();
        }
    }
    public class jsonBranchesWrapper{
        @AuraEnabled public string Id;
        @AuraEnabled public string Name;
        @AuraEnabled public boolean isChecked;
        @AuraEnabled public List<branchesWrapper> branches;   
        public jsonBranchesWrapper(){
            branches = new List<branchesWrapper>();
        }
    }
    public class branchesWrapper{
        @AuraEnabled public string Id;
        @AuraEnabled public string Name;
        @AuraEnabled public boolean isChecked;                
    }
}