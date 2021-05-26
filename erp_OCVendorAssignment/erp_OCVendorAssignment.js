import { LightningElement, wire, api } from 'lwc';
import getVendorData from '@salesforce/apex/ERP_FlowDuallistboxController.getVendorData';

export default class Erp_OCVendorAssignment extends LightningElement {
    
    vendorResult;
    error;
    @api selectedVendor = '';
    @api outputVendor = '';


    @wire(getVendorData)
    wiredRecords({ error, data }) {
        if (data) {
            this.vendorResult = data;
            this.error = undefined;
        } else if(error){
            this.error = error;
        }
    }
    

    handleChange(event){
        this.selectedVendor = event.target.value;
        console.log("vendorName+++ "+this.selectedVendor);
        for (let i of this.selectedVendor) {
            var taskName = this.vendorResult.find(data=> data.value === i);
            this.outputVendor += taskName.label +', ';
            
        }
        this.outputVendor = this.outputVendor.slice(0, -2);
       

    }

}