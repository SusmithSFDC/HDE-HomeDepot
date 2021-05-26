public class erp_TaskChainedComparator  extends erp_Comparator{
    
    private List<erp_Comparator> comparators;
    
    public erp_TaskChainedComparator(List<erp_Comparator> comparators){
        this.comparators = comparators;
    }
    
    public override Integer compare(Object a, Object b) {
        for(erp_Comparator comparator : comparators){
            Integer result = comparator.compare(a, b);
            if(result != 0){
                return result;
            }
        }
        return 0;
        /*if (((erp_TaskAssignment)a).divisionPriority > ((erp_TaskAssignment)b).divisionPriority) {
            return 1;
        } else if (((erp_TaskAssignment)a).divisionPriority < ((erp_TaskAssignment)b).divisionPriority) {
            return -1;
        }else{
            return 0;
        }*/
    }
}