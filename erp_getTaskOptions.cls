public class erp_getTaskOptions {
    
    @InvocableMethod(label = 'Get Task Options')
    public static List<Results> getTaskOptions() {
        List<Results> resultList = new List<Results>();
        List<String> tasks = System.Label.ERP_IC_TASKS.split(';');
        Results currentResult = new Results();
        
        List<erp_CheckboxGroupOptions> options = new List<erp_CheckboxGroupOptions>();
        for(String task : tasks){
            erp_CheckboxGroupOptions option = new erp_CheckboxGroupOptions();
            option.label = task;
            option.value = task;
            options.add(option);
        }
        
        currentResult.options = JSON.serialize(options);
        resultList.add(currentResult);
        return resultList;
    }
    
    public class Results {
        @InvocableVariable
        public String options;
    }
}