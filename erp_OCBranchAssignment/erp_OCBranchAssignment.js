import { LightningElement,wire,api } from 'lwc';
import getRegionBranches from '@salesforce/apex/ERP_FlowDuallistboxController.getRegionBranchesData';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class Erp_OCBranchAssignment extends LightningElement {
    @api
    availableActions = [];
    result;
    @api branchLabel = '';
    @api selectedBranches = [];
    @api outputBranches = '';

    @wire(getRegionBranches)
    wiredRecords({ error, data }) {
        console.log("test Wire: +++");
        if (data) {
            this.result = data;
            console.log('records++'+JSON.stringify(data));
            this.error = undefined;
        } else if(error){
            console.log('error++'+JSON.stringify(error));
            this.error = error;
        }
        console.log("availableActions++"+JSON.stringify(this.availableActions));
    }

    handleChange(event){
        this.selectedBranches = event.target.value;
        console.log("selectedbranches+++ "+this.selectedBranches);
        for (let i of this.selectedBranches) {  
            console.log(" iiii+++"+i);   
            var selected = this.result.find(data=> data.value === i);
            this.outputBranches += selected.label +', ';
        }
        console.log("outputBranches++"+this.outputBranches);
        this.outputBranches = this.outputBranches.slice(0, -2);
    }

}