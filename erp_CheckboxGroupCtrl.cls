public class erp_CheckboxGroupCtrl {
    
    @InvocableMethod(label = 'Available Options')
    public static List<Results> getCheckboxGroupOptions(List<String> request) {
        
        List<Results> resultList = new List<Results>();
        Results currentResult = new Results();
        List<erp_CheckboxGroupOptions> options = new List<erp_CheckboxGroupOptions>();
        List<erp_CheckboxGroupOptions> otherOptions = new List<erp_CheckboxGroupOptions>();
        switch on request[0].toUpperCase(){
            when 'PRODUCT'{
                List<String> productCodes = System.Label.erp_Product_Codes.split(',');
                List<Product2> products = [Select Id, Name, Abbreviation__c,family from Product2 where IsActive = true and Family in ('HDE','HDI')
                                           and ProductCode in :productCodes order by family desc,name ASC];
                
                for(Product2 product : products){
                    
                    erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
                    option.label = product.Name +' '+ product.Abbreviation__c; 
                    option.value = product.Id;
                    option.family = product.Family;
                    options.add(option);                                                                                
                }
                
            }
            when 'TASK'{
                List<String> tasks = System.Label.ERP_IC_TASKS.split(';');
                
                for(String task : tasks){
                    erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
                    option.label = task;
                    option.value = task;
                    options.add(option);
                }
            }
            when 'BRANCH'{                
                for(Business_Unit__c branch : [SELECT Id, Name FROM Business_Unit__c WHERE Type__c = 'Install Branch' and LOB__c = 'HDIS' order by Name]){
                    erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
                    option.label = branch.Name;
                    option.value = branch.Id;
                    options.add(option);
                }
            }
            when 'INSTALL DIVISION'{                
                for(Business_Unit__c branch : [SELECT id, Name FROM Business_Unit__c WHERE Type__c = 'Install Division' AND LOB__c = 'HDIS']){
                    erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
                    option.label = branch.Name;
                    option.value = branch.Id;
                    options.add(option);
                }
            }
            when 'VENDOR'{                
                for(Account acc: [select id, Name, AccountNumber, Active__c, Line_Of_Business__c from Account 
                          where  Active__c = true and Line_Of_Business__c = 'HDE' and (NOT AccountNumber like '9__')]){
                    erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
                    option.label = acc.Name;
                    option.value = acc.Name;
                    options.add(option);
                }
            }
            when 'OCTASK'{
                List<String> tasks = System.Label.ERP_OC_Tasks.split(';');
                
                for(String task : tasks){
                    erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
                    option.label = task;
                    option.value = task;
                    options.add(option);
                }
            }
        }
        
        currentResult.options = JSON.serialize(options);
        resultList.add(currentResult);
        system.debug('resultList+'+resultList);
        return resultList;
    }
    
    public class Results {
        @InvocableVariable
        public String options;
    }
}