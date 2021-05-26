public class erp_TaskAssignment implements Comparable{
    
    public String id;
    public String taskName;
    public String divisionName;
    public Integer divisionPriority;
    public String regionName;
    public Integer regionPriority;
    public String productName;
    public Integer productPriority;
    public String vendorName;
    public Integer vendorPriority;
    public Integer taskPriority;
    public Integer jobAge;
    
    public erp_TaskAssignment(String id, String taskName, 
                              String divisionName ,Integer divisionPriority, 
                              String regionName, Integer regionPriority,
                              String productName, Integer productPriority,
                              String vendorName, Integer vendorPriority,
                              Integer taskPriority, Integer jobAge){
                                  this.id = id;
                                  this.taskName = taskName;
                                  this.divisionName = divisionName;
                                  this.divisionPriority = divisionPriority;
                                  this.regionName = regionName;
                                  this.regionPriority = regionPriority;
                                  this.productName = productName;
                                  this.productPriority = productPriority;
                                  this.vendorName = vendorName;
                                  this.vendorPriority = vendorPriority;
                                  this.taskPriority = taskPriority;
                                  this.jobAge = jobAge;
                              }
    
    public Integer compareTo(Object compareTo) {
        erp_TaskAssignment compareToRec = (erp_TaskAssignment)compareTo;
        if (divisionPriority > compareToRec.divisionPriority) {
            return 1;
        } else if (divisionPriority < compareToRec.divisionPriority) {
            return -1;
        } else {
            if (regionPriority > compareToRec.regionPriority) {
                return 1;
            } else if (regionPriority < compareToRec.regionPriority) {
                return -1;
            } else {
                if (productPriority > compareToRec.productPriority) {
                    return 1;
                } else if (productPriority < compareToRec.productPriority) {
                    return -1;
                } else {
                    if (vendorPriority > compareToRec.vendorPriority) {
                        return 1;
                    } else if (vendorPriority < compareToRec.vendorPriority) {
                        return -1;
                    } else {
                        if (taskPriority > compareToRec.taskPriority) {
                            return 1;
                        } else if (taskPriority < compareToRec.taskPriority) {
                            return -1;
                        } else {
                            if (jobAge < compareToRec.jobAge) {
                                return 1;
                            } else if (jobAge > compareToRec.jobAge) {
                                return -1;
                            } else {
                                return 0;        
                            }        
                        }       
                    }         
                }         
            }          
        }       
    } 
}