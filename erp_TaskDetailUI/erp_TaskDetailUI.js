import { LightningElement,wire,api } from 'lwc';
import getTaskRecordDetails from '@salesforce/apex/ERP_TaskDetailUIController.getTaskRecordDetails';

export default class Erp_TaskDetailUI extends LightningElement {
    @api recordId  = '';//for testing purpose passing hard code task id
    taskData =[];
    //@api jobNumber;
    errorMessage;

    connectedCallback() {
        //Get task data when components loads
        this.fetchTaskDetails();
    }


    fetchTaskDetails () {
        if(this.recordId) {
            getTaskRecordDetails({
                recordId : this.recordId
            })
            .then(result =>{
                this.taskData = JSON.parse(result);
                //const regEx = />([^<]*)</;
                //this.jobNumber = regEx.exec(this.taskData.jobNumber)[1];
                console.log('==data=== '+JSON.stringify(this.taskData));
            }) 
            .catch(error =>{
                this.errorMessage = error;
                console.log('==error=== '+this.errorMessage);
            })
        }
    }


}