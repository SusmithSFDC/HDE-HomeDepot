/**
* Class for HDE ERP to assign Store Product for Field Users
* 
* */
public class erp_UserAssignmentCtrl {
    
    @AuraEnabled
    public static List<erp_StoreProduct> getStoreProductList(String branchId, List<String> productIds, String userAssignmentId) {
        List<erp_StoreProduct> storeProductList = new List<erp_StoreProduct>();
        map<Id,String> mapStores = new map<Id,String>();
        map<String,String> mapProducts = new map<String,String>();
        map<Decimal,List<boolean>> mapDistricts = new map<Decimal,List<boolean>>();
        system.debug('branch --' +branchId);
        system.debug('productIds --' +productIds);
        Set<String> selectedProducts = new Set<String>(productIds);
        set<Id> setBranchIds = new set<Id>();
        Map<String, String> mapProductsFamily = new Map<String, String>();
        //Get user role
        List<User_Assignment__c> lstUserAssignment = [SELECT Id, User_Role__c FROM User_Assignment__c WHERE Id=: userAssignmentId LIMIT 1];
        
        //Getting HDE and HDI branch ids from parent HDIS id.
        List<business_unit__c> lstBranches = [select id from business_unit__c where Parent__c =: branchId];
        for(business_unit__c bu : lstBranches){
            setBranchIds.add(bu.id);
        }
        List<Store_Business_Unit__c> storeBranches = [Select Id,Branch__r.Name,Store__c, Store__r.Name,Store_Code__c, 
                                                      Store__r.District_Number__c from Store_Business_Unit__c 
                                                      where Branch__c in (select Id from Business_Unit__c 
                                                                          where Install_Branch__c in :setBranchIds)
                                                      and Store__r.District_Number__c != null];
        //If Role is DIM , then populating products family map.
        if(!lstUserAssignment.isEmpty() && lstUserAssignment[0].User_Role__c.equals(erp_JMConstant.DISTRICT_INSTALLATION_MANAGER)){
            for(product2 prd : [select id, name, family from product2 where id in: selectedProducts]){
                mapProductsFamily.put(prd.id,prd.Family);
            }
        }                
        
        List<User_Additional_Assignment__c> lstAdditionalAssignment = [select id,name,Product2__c,Product2__r.name,Store__c,Store__r.name,Store__r.District_Number__c from User_Additional_Assignment__c where User_Assignment__c =: userAssignmentId and Type__c='Store Product']; //(select id,name from User_Branch_Assignments__r)
        for(User_Additional_Assignment__c assignment : lstAdditionalAssignment){
            mapStores.put(assignment.Store__c,assignment.Store__r.name);
            mapProducts.put(assignment.Store__c+'-'+assignment.Product2__c,assignment.Product2__r.name);
        }
        system.debug('mapStores++'+mapStores);
        system.debug('mapProducts++'+mapProducts);
        List<Id> storeIds = new List<Id>();
        try{
            system.debug('storeBranches++'+storeBranches);
            
            if(!storeBranches.isEmpty()){
                
                for(Store_Business_Unit__c storeBranch : storeBranches){
                    storeIds.add(storeBranch.Store__c);
                }
                Map<Id, List<Product2>> storeProducts = new Map<Id, List<Product2>>();
                AggregateResult[] groupedResults = [SELECT Product__c,Product__r.Name , Store__c
                                                    FROM Store_Product__c 
                                                    WHERE Store__c in :storeIds AND Active__c = true 
                                                    AND Product_Family__c in ('HDE','HDI')
                                                    GROUP BY Product__c,Product__r.Name , Store__c];
                system.debug('groupedResults++'+groupedResults);
                for (AggregateResult ar : groupedResults)  {
                    if(storeProducts.containsKey((Id)ar.get('Store__c'))){
                        storeProducts.get((Id)ar.get('Store__c')).add(new Product2(Id=(Id) ar.get('Product__c'), Name = (String)ar.get('Name')));
                    }else{
                        List<Product2> products = new List<Product2>{new Product2(Id=(Id) ar.get('Product__c'), Name = (String)ar.get('Name'))};
                            storeProducts.put((Id)ar.get('Store__c') , products);
                    }
                }
                System.debug('storeProducts --> '+storeProducts);
                Map<Decimal, List<erp_StoreProduct.Store>> storesByDistrict = new Map<Decimal , List<erp_StoreProduct.Store>>();
                map<Decimal,String> mapStoreSelected = new map<Decimal,String>();
                System.debug('storeBranches --> '+storeBranches);
                for(Store_Business_Unit__c store1: storeBranches){
                    Boolean prodAddAssignment = false;
                    erp_StoreProduct.Store storeList = new erp_StoreProduct.Store();
                    storeList.id = store1.Store__c;
                    storeList.name = store1.Store_Code__c +' - '+store1.Store__r.Name;
                    storeList.storeCode = store1.Store_Code__c;
                    List<erp_StoreProduct.Product> products = new List<erp_StoreProduct.Product>();
                    if(storeProducts.get(store1.Store__c) == null){
                        continue;
                    }
                    for(Product2 product : storeProducts.get(store1.Store__c)){
                        if(selectedProducts.contains(product.Id)){
                            erp_StoreProduct.Product availableProduct = new erp_StoreProduct.Product();
                            availableProduct.id = product.Id;
                            availableProduct.uniqueId = String.valueOf(store1.Store__c)+String.valueOf(product.Id);
                            availableProduct.name = product.Name;
                            system.debug('mapProductsFamily++'+mapProductsFamily);
                            system.debug('mapProductsFamily.containsKey(product.Id)++'+mapProductsFamily.containsKey(product.Id));
                            if(!mapProductsFamily.isEmpty() && mapProductsFamily.containsKey(product.Id)){
                                availableProduct.family = mapProductsFamily.get(product.Id);
                            }
                            
                            system.debug('product++'+product);
                            //If product is already exists in addition assignment , then it will be pre-selected.
                            if(!mapProducts.isEmpty() && mapProducts.containsKey(store1.Store__c+'-'+product.Id)){                                
                                availableProduct.isChecked = true;
                                prodAddAssignment = true;
                            }
                            else{                                
                                availableProduct.isChecked = false;
                            }
                            
                            products.add(availableProduct);
                        }
                    }
                    if(products.isEmpty()){
                        continue;
                    }
                    storeList.products = products;
                    //If store is already exists in additional assignement or product is HDE ,then pre-selecting the store.
                    if(!mapStores.isEmpty() && mapStores.containsKey(store1.Store__c) && prodAddAssignment){
                        storeList.isChecked = true;
                        mapStoreSelected.put(store1.Store__r.District_Number__c,store1.Store__c);
                    }
                    else{
                        storeList.isChecked = false;
                    }
                    system.debug('district : '+store1.Store__r.District_Number__c);
                    if(storesByDistrict.containsKey(store1.Store__r.District_Number__c)){
                        storesByDistrict.get(store1.Store__r.District_Number__c).add(storeList);
                        mapDistricts.get(store1.Store__r.District_Number__c).add(storeList.isChecked);
                    }else{
                        List<erp_StoreProduct.Store> stores = new List<erp_StoreProduct.Store>{storeList};
                            storesByDistrict.put(store1.Store__r.District_Number__c , stores);    
                            mapDistricts.put(store1.Store__r.District_Number__c,new List<boolean>{storeList.isChecked});
                    }
                }
                system.debug('storesByDistrict --> '+storesByDistrict);
                for(Decimal key : storesByDistrict.keySet()){
                    erp_StoreProduct storeList = new erp_StoreProduct();
                    storeList.id = String.valueOf(key);
                    storeList.name = 'District - '+String.valueOf(key);
                    //If all store product is selected then select district.
                    if( (!mapDistricts.isEmpty() && mapDistricts.containsKey(key) && !mapDistricts.get(key).contains(false)) ) {
                        storeList.isChecked = true;
                    }else{
                        storeList.isChecked = false;
                    }
                    // if store is preselected then we are making this showDistrict  as true 
                    if(!mapStoreSelected.isEmpty() && mapStoreSelected.containsKey(key)){
                        storeList.showDistrict = true;
                    }
                    storeList.stores = storesByDistrict.get(key);
                    storeList.userRole = lstUserAssignment[0].User_Role__c;
                    storeProductList.add(storeList);//
                }
            }
        }catch(Exception ex){
            System.debug(Logginglevel.ERROR, 'Exception occured when obtaining store product '+ex);
        }
        system.debug('storeProductList -->' +storeProductList);
        return storeProductList;
    }  
    
    @InvocableMethod
    public static void saveUserAssignment(List<FlowInput> requests) {
        FlowInput request = requests[0];
        System.debug('request --> ' +request);
        User fieldUser = getUserDetails(request.userAssignmentRecordId);
        Set<String> selectedProducts = new Set<String>();
        if(request.productIds != null){
            selectedProducts.addAll(request.productIds);
        }
        User_Branch_Assignment__c userBranchAssignment = getCurrentAssignment(request.userAssignmentRecordId);
        userBranchAssignment = getUserBranchAssignment(userBranchAssignment,request,fieldUser);
        List<User_Additional_Assignment__c> currentAdditionalAssingments = getUserAsstionalAssignment(request.userAssignmentRecordId);
        List<User_Additional_Assignment__c> additionalAssignments = new List<User_Additional_Assignment__c>();
        List<User_Additional_Assignment__c> deleteAssignments = new List<User_Additional_Assignment__c>();
        for(String product : selectedProducts){
            additionalAssignments.add(new User_Additional_Assignment__c(Type__c ='Product', 
                                                                        User__c = fieldUser.Id, 
                                                                        Product2__c = product,
                                                                        User_Assignment__c = request.userAssignmentRecordId));
        }
         
        if(String.isNotBlank(request.storeProducts)) {
           List<erp_StoreProduct> listStoreProducts = (List<erp_StoreProduct>) JSON.deserialize(request.storeProducts, List<erp_StoreProduct>.class);
            for (erp_StoreProduct storeProduct : listStoreProducts) {//district
                for (erp_StoreProduct.Store store : storeProduct.stores) {
                    if (store.isChecked) {
                        for (erp_StoreProduct.Product product : store.products) {
                            if (product.isChecked) {
                                additionalAssignments.add(new User_Additional_Assignment__c(Type__c = 'Store Product',
                                        User__c = fieldUser.Id,
                                        Product2__c = product.Id,
                                        Store__c = store.id,
                                        User_Assignment__c = request.userAssignmentRecordId));
                            }
                        }
                    }
                }
            }
        }

        if(String.isNotBlank(request.selectedTaskProducts)){
           List<erp_TaskProducts> listTaskProducts = (List<erp_TaskProducts>) JSON.deserialize(request.selectedTaskProducts, List<erp_TaskProducts>.class);
            System.debug('listTaskProducts ++ ' + listTaskProducts);
            for(erp_TaskProducts task : listTaskProducts){
                if(task.isChecked){
                    for(erp_TaskProducts.Product product : task.products){
                        if(product.isChecked){
                            additionalAssignments.add(new User_Additional_Assignment__c(Type__c = 'Task', 
                                                      Task__c = task.taskName,
                                                      Product2__c = product.Id,
                                                      User__c = fieldUser.Id,
                                                      User_Assignment__c = request.userAssignmentRecordId));
                            System.debug('taskProducts ++ ' + product);
                        }
                    }
                }
            }
        }

        List<User_Additional_Assignment__c> duplicateAssignments = getDuplicateAssignments(request.userAssignmentRecordId, request.storeProducts);
        if(currentAdditionalAssingments != null ){
            delete currentAdditionalAssingments;
        }

        List<User_Additional_Assignment__c> previousJobContactsToUpdate = new List<User_Additional_Assignment__c>();
        if(!duplicateAssignments.isEmpty()){
            //Map<StoreProduct, UserId>
            Map<String,String> duplicates = new Map<String, String>();
            List<User_Additional_Assignment__c> dupAssigmentsList = [SELECT Product2__c, Store__c , User__c
                                                                     FROM User_Additional_Assignment__c
                                                                     WHERE Id IN :duplicateAssignments];
            for(User_Additional_Assignment__c dupAssignments: dupAssigmentsList){
                duplicates.put(dupAssignments.Store__c+'-'+dupAssignments.Product2__c, dupAssignments.User__c);
            }
            for(User_Additional_Assignment__c userAssigments: additionalAssignments){
                String newUserAssignment = userAssigments.Store__c+'-'+userAssigments.Product2__c;
                if(duplicates.containsKey(newUserAssignment)){
                    userAssigments.Previous_User__c = duplicates.get(newUserAssignment);
                    previousJobContactsToUpdate.add(userAssigments);
                }
            }
        }

        system.debug('additionalAssignments -->' +additionalAssignments);
        system.debug('userBranchAssignment -->' +userBranchAssignment);
        try{
            upsert userBranchAssignment;
            if(!fieldUser.Field_Role__c.equalsIgnoreCase(erp_JMConstant.WAREHOUSE_ASSOICATE)){
                delete duplicateAssignments;
                upsert additionalAssignments;
                if(!previousJobContactsToUpdate.isEmpty()){
                   erp_UserAssingmentService.updateJobContactsAndTasks(previousJobContactsToUpdate, fieldUser, true);//request.reassignOpenTask
                }
            }
            if(fieldUser.Field_Role__c != erp_JMConstant.INSTALLATION_COORDINATOR && fieldUser.Field_Role__c != erp_JMConstant.ORDERING_COORDINATOR){
               erp_LMSSyncLogCallout.syncUserAssignment(request.userAssignmentRecordId);
            }
        }catch(Exception ex){
            System.debug('Exception occured when saving User assignment '+ex);
            System.debug(Logginglevel.ERROR, 'Exception occured when saving store product '+ex);
        }

    }


    
    private static List<User_Additional_Assignment__c> getDuplicateAssignments(String userAssignmentRecordId, String storeProducts){
        
        List<User_Additional_Assignment__c> useradditionaAssignmentIds = new List<User_Additional_Assignment__c>();
        System.debug('storeProducts >> ' +storeProducts);
        if(String.isBlank(storeProducts)){
            return useradditionaAssignmentIds;
        }
        erp_DuplicateAssignmentCtrl.FlowInput duplicateValidationRequest = new erp_DuplicateAssignmentCtrl.FlowInput();
        duplicateValidationRequest.userAssignmentRecordId = userAssignmentRecordId;
        duplicateValidationRequest.storeProducts = storeProducts;
        List<erp_DuplicateAssignmentCtrl.FlowInput> duplicateValidationRequests = new List<erp_DuplicateAssignmentCtrl.FlowInput>{duplicateValidationRequest};
        List<erp_DuplicateAssignmentCtrl.Response> validateResults = erp_DuplicateAssignmentCtrl.validateDuplicateAssignment(duplicateValidationRequests);
        if(String.isNotBlank(validateResults[0].duplicateAssignment)) {
            List<erp_DuplicateAssignmentCtrl.UserAssingment> listDuplicateStoreProducts = (List<erp_DuplicateAssignmentCtrl.UserAssingment>)JSON.deserialize(validateResults[0].duplicateAssignment, List<erp_DuplicateAssignmentCtrl.UserAssingment>.class);
            for(erp_DuplicateAssignmentCtrl.UserAssingment userAssignment : listDuplicateStoreProducts){
                for(String store : userAssignment.storeProducts.keySet()){
                    for(erp_DuplicateAssignmentCtrl.StoreProduct storeProduct : userAssignment.storeProducts.get(store)){
                        useradditionaAssignmentIds.add(new User_Additional_Assignment__c(id = storeProduct.userAddionalAssignmentId));
                    }
                }
                
            }
        }
        return useradditionaAssignmentIds;
    }
    
    public static User_Branch_Assignment__c getCurrentAssignment(String userAssignmentRecordId){
        List<User_Branch_Assignment__c> userHomeBranchs = [Select Id, Business_Unit__c,User__c from User_Branch_Assignment__c
                                                   Where User_Assignment__c = :userAssignmentRecordId
                                                   And Type__c = 'Home'];
        return (!userHomeBranchs.isEmpty() ? userHomeBranchs[0]: null);
    }
    
    private static User_Branch_Assignment__c getUserBranchAssignment(User_Branch_Assignment__c userBranchAssignment,
                                               FlowInput request, User fieldUser){
        if(userBranchAssignment == null){
            userBranchAssignment = new User_Branch_Assignment__c(
                                            Business_Unit__c = request.branchId,
                                            User__c = fieldUser.Id,
                                            Type__c = 'Home',
                                            User_Assignment__c = request.userAssignmentRecordId);
        }else if(userBranchAssignment.Business_Unit__c != request.branchId){//Branch is getting updated
            userBranchAssignment.Business_Unit__c = request.branchId;
        }
        return userBranchAssignment;                                            
    }
    
    private static User getUserDetails(String userAssignmentRecordId){
        //Install Role
        String userId = [SELECT Id, Name, User__c FROM User_Assignment__c WHERE Id = :userAssignmentRecordId].User__c;
        User user = [SELECT Id, Name,Field_Role__c  FROM User WHERE Id = :userId];
        return user;
    } 
    
    private static List<User_Additional_Assignment__c> getUserAsstionalAssignment(String userAssignmentRecordId){
        List<User_Additional_Assignment__c> userAssignments = [Select Id,Type__c,Product2__c,Store__c FROM User_Additional_Assignment__c
                                                                  Where User_Assignment__c = :userAssignmentRecordId];
        return (!userAssignments.isEmpty())? userAssignments : null;
    }
     
    public class FlowInput{
        @InvocableVariable
        public String userAssignmentRecordId;
        @InvocableVariable
        public String branchId;
        @InvocableVariable
        public List<String> productIds;
        @InvocableVariable
        public String storeProducts;
        @InvocableVariable
        public String selectedTaskProducts;
        @InvocableVariable//depricated
        public List<String> selectedTasks;
        @InvocableVariable
        public Boolean reassignOpenTask;

    }
    
}