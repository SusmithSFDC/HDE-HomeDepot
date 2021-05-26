public class erp_TaskSorting {
    
    public class DivisionComparator extends erp_Comparator {
        public override Integer compare(Object a, Object b) {
            if (((erp_TaskAssignment)a).divisionPriority > ((erp_TaskAssignment)b).divisionPriority) {
                return 1;
            } else if (((erp_TaskAssignment)a).divisionPriority < ((erp_TaskAssignment)b).divisionPriority) {
                return -1;
            }else{
                return 0;
            }
        }
    }
    
    public class RegionComparator extends erp_Comparator {
        public override Integer compare(Object a, Object b) {
            if (((erp_TaskAssignment)a).regionPriority > ((erp_TaskAssignment)b).regionPriority) {
                return 1;
            } else if (((erp_TaskAssignment)a).regionPriority < ((erp_TaskAssignment)b).regionPriority) {
                return -1;
            }else{
                return 0;
            }
        }
    }
    
    public class ProductComparator extends erp_Comparator {
        public override Integer compare(Object a, Object b) {
            if (((erp_TaskAssignment)a).productPriority > ((erp_TaskAssignment)b).productPriority) {
                return 1;
            } else if (((erp_TaskAssignment)a).productPriority < ((erp_TaskAssignment)b).productPriority) {
                return -1;
            }else{
                return 0;
            }
        }
    }
    
    public class VendorComparator extends erp_Comparator {
        public override Integer compare(Object a, Object b) {
            if (((erp_TaskAssignment)a).vendorPriority > ((erp_TaskAssignment)b).vendorPriority) {
                return 1;
            } else if (((erp_TaskAssignment)a).vendorPriority < ((erp_TaskAssignment)b).vendorPriority) {
                return -1;
            }else{
                return 0;
            }
        }
    }
    public class TaskComparator extends erp_Comparator {
        public override Integer compare(Object a, Object b) {
            if (((erp_TaskAssignment)a).taskPriority > ((erp_TaskAssignment)b).taskPriority) {
                return 1;
            } else if (((erp_TaskAssignment)a).taskPriority < ((erp_TaskAssignment)b).taskPriority) {
                return -1;
            }else{
                return 0;
            }
        }
    }
    
    public class JobAgeComparator extends erp_Comparator {
        public override Integer compare(Object a, Object b) {
            if (((erp_TaskAssignment)a).jobAge < ((erp_TaskAssignment)b).jobAge) {
                return 1;
            } else if (((erp_TaskAssignment)a).jobAge > ((erp_TaskAssignment)b).jobAge) {
                return -1;
            }else{
                return 0;
            }
        }
    }
}