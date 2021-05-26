/**
* Class used for HDE ERP to determine Store Product duplicate assignment
* */
public class erp_DuplicateAssignmentCtrl {

    @InvocableMethod(label = 'Validate for duplicate assignment')
    public static List<Response> validateDuplicateAssignment(List<FlowInput> requests) {
        FlowInput request = requests[0];
        List<Response> responseList = new List<Response>();
        Response response = new Response();
        List<String> duplicateAssignmentMessages = new List<String>();
        String currentUserRole = getCurrentUserRole(request.userAssignmentRecordId);
        List<User_Additional_Assignment__c> currentAssignments = getAssignedStoreProducts(currentUserRole,request.userAssignmentRecordId);
        Set<String> duplicateUserName = new Set<String>();
        Map<Id, String> duplicates = new Map<Id, String>();
        List<erp_StoreProduct> selectedStoreProducts = (List<erp_StoreProduct>)JSON.deserialize(request.storeProducts, List<erp_StoreProduct>.class);
        response.duplicateAssignment = getDuplicateAssignmentText(currentAssignments,selectedStoreProducts);
        responseList.add(response);
        return responseList;
    }


    public class Response {
        @InvocableVariable
        public String duplicateAssignment;
    }

    public class FlowInput {
        @InvocableVariable
        public String userAssignmentRecordId;
        @InvocableVariable
        public String storeProducts;
    }

    @TestVisible
    private static String getCurrentUserRole(String userAssignmentId){
        return [Select Id,User_Role__c from User_Assignment__c where Id = :userAssignmentId].User_Role__c;
    }

    @TestVisible
    private static List<User_Additional_Assignment__c> getAssignedStoreProducts(String userRole, String currentUserAssignmentId){
        List<User_Additional_Assignment__c> assingments = [SELECT Id,User_Assignment__r.Name,store__c,
                                                           store__r.Name,product2__c, product2__r.Name,
                                                           User_Assignment__c FROM User_Additional_Assignment__c
                                                           WHERE User_Assignment__r.User_Role__c = :userRole
                                                           AND Type__c = 'Store Product'
                                                           AND User_Assignment__c != :currentUserAssignmentId
                                                           ORDER by store__r.Name asc];
        
        return assingments;
    }

    @TestVisible
    private static String getDuplicateAssignmentText(List<User_Additional_Assignment__c> currentAssignments, List<erp_StoreProduct> selectedStoreProducts){
        Map<Id, UserAssingment> duplicateAssignmentMap = getDuplicateAssignments(currentAssignments,selectedStoreProducts);
        if(duplicateAssignmentMap != null && !duplicateAssignmentMap.isEmpty()){
            List<UserAssingment> duplicateAssignments = duplicateAssignmentMap.values();
            return JSON.serialize(duplicateAssignments);
        }
        return null;
    }

    private static Map<Id, UserAssingment> getDuplicateAssignments(List<User_Additional_Assignment__c> currentAssignments,
            List<erp_StoreProduct> selectedStoreProducts){
        //Map<User_Assignment__c, UserAssingment>
        Map<Id, UserAssingment> duplicateAssignmentMap = new Map<Id, UserAssingment>();
        for(erp_StoreProduct selectedStoreProduct: selectedStoreProducts){//district
            for(erp_StoreProduct.Store store: selectedStoreProduct.stores){
                if(store.isChecked){//selected store
                    for(erp_StoreProduct.Product product: store.products){
                        if(product.isChecked){//selected product
                            //compare if there is a user with same store product
                            for(User_Additional_Assignment__c alreadyAssigned: currentAssignments) {
                                
                                if(alreadyAssigned.Store__c.equals(store.Id) && alreadyAssigned.Product2__c.equals(product.Id) ) {
                                    StoreProduct storeProduct = new StoreProduct();
                                    storeProduct.userAddionalAssignmentId = alreadyAssigned.Id;
                                    storeProduct.productName = alreadyAssigned.Product2__r.Name;
                                    storeProduct.storeCode = alreadyAssigned.Store__r.Name;
                                    if(duplicateAssignmentMap.containsKey(alreadyAssigned.User_Assignment__c)){// duplicate assignment doesn't exists
                                        UserAssingment duplicateAssignment = duplicateAssignmentMap.get(alreadyAssigned.User_Assignment__c);
                                        if(duplicateAssignment.storeProducts != null && duplicateAssignment.storeProducts.containsKey(alreadyAssigned.Store__r.Name)){//already assigned to the store
                                            duplicateAssignment.storeProducts.get(alreadyAssigned.Store__r.Name).add(storeProduct);
                                        }else{//assigning new store product combination
                                            duplicateAssignment.storeProducts.put(alreadyAssigned.Store__r.Name, new List<StoreProduct>{storeProduct});
                                        }
                                    }else{//encountered duplicate for the first time
                                        UserAssingment duplicateAssignment = new UserAssingment();
                                        duplicateAssignment.userAssignmentId = alreadyAssigned.User_Assignment__c;
                                        duplicateAssignment.userName = alreadyAssigned.User_Assignment__r.Name;
                                        duplicateAssignment.storeProducts = new Map<String, List<StoreProduct>>();
                                        duplicateAssignment.storeProducts.put(alreadyAssigned.Store__r.Name, new List<StoreProduct>{storeProduct});
                                        duplicateAssignmentMap.put(alreadyAssigned.User_Assignment__c, duplicateAssignment);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return duplicateAssignmentMap;
    }


    public Class UserAssingment{
        @AuraEnabled
        public String userAssignmentId;
        @AuraEnabled
        public String userName;
        //Map<StoreName, List<StoreProduct>>
        @AuraEnabled
        public Map<String, List<StoreProduct>> storeProducts;
    }

    public Class StoreProduct{
        @AuraEnabled
        public String userAddionalAssignmentId;
        @AuraEnabled
        public String storeCode;
        @AuraEnabled
        public String productName;
    }

}