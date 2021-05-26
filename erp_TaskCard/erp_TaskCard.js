import { LightningElement, track } from 'lwc';
import getNextTask from '@salesforce/apex/erp_GetNextTaskCtrl.getNextTask';

export default class Erp_TaskCard extends LightningElement {
    @track isGetNextTaskClicked = false;
    @track taskName = '';
    @track error = '';

    handleClick() {
        getNextTask({ userId: '' })
            .then(data => {
                this.taskName = data;
                this.error = null;
            })
            .catch(error => {
                this.error = error;
            });
        this.isGetNextTaskClicked = true;
    }
}