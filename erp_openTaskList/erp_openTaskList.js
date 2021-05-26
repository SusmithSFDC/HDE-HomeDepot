import { LightningElement, api } from 'lwc';
import getAllTasks from '@salesforce/apex/ERP_TaskDetailUIController.getAllTasks';


export default class Erp_openTaskList extends LightningElement {
    taskList = [];
    errorMessage;
    connectedCallback() {
        //Get task data when components loads
        this.fetchAllTasks();
    }


    fetchAllTasks() {
        getAllTasks({
            //recordId : this.recordId
        })
            .then(result => {
                this.taskList = JSON.parse(result);
                console.log('==data==taskList= ' + JSON.stringify(this.taskList));
            })
            .catch(error => {
                this.errorMessage = error;
                console.log('==error=== ' + this.errorMessage);
            })

    }

}