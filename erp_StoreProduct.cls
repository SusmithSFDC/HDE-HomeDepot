public class erp_StoreProduct {
    
    @AuraEnabled
    public String id{get;set;}//district Number
    @AuraEnabled
    public String name{get;set;}//district Number
    @AuraEnabled
    public boolean isChecked{get;set;}
	@AuraEnabled
    public String userRole{get;set;}
    @AuraEnabled
    public boolean showDistrict{get;set;}
    
    @AuraEnabled
    public List<Store> stores{get;set;}
    
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
        
    }
    
    public class Store{
        @AuraEnabled
        public String id{get;set;}
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
    	public String storeCode{get;set;}
        @AuraEnabled
        public boolean isChecked{get;set;}
        @AuraEnabled
        public List<Product> products {get;set;}
    }

}