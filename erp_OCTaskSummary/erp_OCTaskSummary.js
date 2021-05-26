import { api, LightningElement } from 'lwc';

export default class Erp_OCTaskSummary extends LightningElement {
    @api taskJSON;
    taskRecords = [];
    connectedCallback() {
        console.log("this.taskJSON"+this.taskJSON);
        var records = [];
        //records = JSON.parse(this.taskJSON); 
        console.log("records"+records);
        if(this.taskJSON != '' && this.taskJSON != undefined && this.taskJSON.length > 0){
            for(let i of this.taskJSON){
                console.log("i="+i);
                records.push(JSON.parse(i));
            }
        }
        this.taskRecords = records;
    }
}