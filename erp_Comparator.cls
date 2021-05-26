public abstract class erp_Comparator {
    

    
    public abstract Integer compare(Object o1, Object o2);
    public static void sort(Object[] values, erp_Comparator comp) {
        //  Obtain the list type of values
        Object[] temp = values.clone();
        temp.clear();
        //  Helper class for sorting using Comparable
        Helper[] tempValues = new Helper[0];
        for(Object value: values) {
            tempValues.add(new Helper(comp, value));
        }
        //  Perform sort
        tempValues.sort();
        //  Extract values back into temp list
        for(Helper helper: tempValues) {
            temp.add(helper.value);
        }
        //  And set the list to the new, sorted order
        values.clear();
        values.addAll(temp);
    }
    //  Simply calls Comparator when asked.
    class Helper implements Comparable {
        erp_Comparator method;
        Object value;
        Helper(erp_Comparator comp, Object val) {
            method = comp;
            value = val;
        }
        public Integer compareTo(Object o) {
            return method.compare(value, ((Helper)o).value);
        }
    }
}