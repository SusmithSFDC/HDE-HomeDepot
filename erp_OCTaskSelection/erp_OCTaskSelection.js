import { api, LightningElement, wire } from 'lwc';
import getTaskData from '@salesforce/apex/ERP_FlowDuallistboxController.getTaskData';

export default class Erp_OCTaskSelection extends LightningElement {

    result;
    
    @api selectedOuputTask = [];
    
    @wire(getTaskData)
    wiredData({ error, data }) {
        if (data) {
            console.log("data++"+data);
            this.result = data;
            this.error = undefined;
        } else if(error){
            console.log("error++"+JSON.stringify(error));
            this.error = error;
        }
    }

    handleChange(event){
        this.selectedOuputTask = [];
        for(let i of event.target.value){
            var selected = this.result.find(data=> data.value === i);
            this.selectedOuputTask.push(selected.label);
        }
        console.log("outputtask++"+this.selectedOuputTask);
    }
}