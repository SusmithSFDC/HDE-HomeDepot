public class erp_TaskProducts {

    @AuraEnabled
    public String taskName{get;set;}
    @AuraEnabled
    public boolean isChecked{get;set;}
    @AuraEnabled
    public List<Product> products{get;set;}
    
    public class Product{
        @AuraEnabled
        public String id{get;set;}
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public String uniqueId{get;set;}
        @AuraEnabled
        public boolean isChecked{get;set;}
        @AuraEnabled
        public string family{get;set;}
        @AuraEnabled
        public string abbreviation{get;set;}
        
    }

}