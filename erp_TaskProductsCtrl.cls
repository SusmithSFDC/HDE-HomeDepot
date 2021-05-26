public class erp_TaskProductsCtrl {
    
    @AuraEnabled
    public static String getTaskProducts(List<String> productIds, String userAssignmentId){
        List<erp_TaskProducts> taskProducts = new List<erp_TaskProducts>();
        List<String> tasks = System.Label.ERP_IC_TASKS.split(';');

        List<Product2> selectedProducts = [SELECT Id, Name, Family, Abbreviation__c FROM Product2
                                           WHERE Id IN :productIds
                                           ORDER BY Family DESC, Name ASC];
        System.debug('selectedProducts > ' + selectedProducts);

        List<User_Additional_Assignment__c> assignedTasks =  [SELECT Id, Type__c, Task__c, Product2__c
                                                              FROM User_Additional_Assignment__c
                                                              WHERE User_Assignment__c = :userAssignmentId
                                                              AND Type__c = 'Task'];

        Map<String, Set<Id>> assignedTaskMap = new Map<String, Set<Id>>();
        for(User_Additional_Assignment__c currentTaskProducts : assignedTasks){
            if(assignedTaskMap.containsKey(currentTaskProducts.Task__c)){
                assignedTaskMap.get(currentTaskProducts.Task__c).add(currentTaskProducts.Product2__c);
            }else{
                assignedTaskMap.put(currentTaskProducts.Task__c, new Set<Id>{currentTaskProducts.Product2__c});
            }
        }
            
        for(String task : tasks){
            erp_TaskProducts taskProduct = new erp_TaskProducts();
            //Added logic to uncheck taskname if product is changed and no longer selected
            //taskProduct.isChecked = assignedTaskMap.containsKey(task) ? true : false;
            if(assignedTaskMap.containsKey(task)){
               boolean productExists = false;
               set<id> setProducts = assignedTaskMap.get(task); 
                for(string productid : productIds){
                    if(setProducts.contains((Id) productid)){
                        productExists =true;
                        break;
                    }
                }
                if(productExists){
                    taskProduct.isChecked = true;
                }
                else{
                    taskProduct.isChecked = false;
                }
            }
            else{
                taskProduct.isChecked = false;
            }
            taskProduct.taskName = task;
            taskProduct.products = new List<erp_TaskProducts.Product>();

            for(Product2 product : selectedProducts){
                erp_TaskProducts.Product taskProduct1 = new erp_TaskProducts.Product();
                taskProduct1.id = product.Id;
                taskProduct1.uniqueId = task + product.Id;
                taskProduct1.isChecked = false;
                if(assignedTaskMap.containsKey(task)){
                    taskProduct1.isChecked = assignedTaskMap.get(task).contains(product.Id) ? true : false;
                }
                taskProduct1.name = product.Name;
                taskProduct1.family = product.Family;
                taskProduct1.abbreviation = product.Abbreviation__c;
                taskProduct.products.add(taskProduct1);
            }
            taskProducts.add(taskProduct);
        }

        String response = JSON.serialize(taskProducts);
        System.debug('response >>> ' + response);
        return response;
    }

}