import { LightningElement, api, wire, track } from 'lwc';
import getAllInstallBranches from '@salesforce/apex/HDEERP_UserAssignmentCtrl.getAllInstallBranches';
import saveHomeBranchAssingment from '@salesforce/apex/HDEERP_UserAssignmentCtrl.saveHomeBranchAssingment';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

let i=0;
export default class Erp_branchassignment extends LightningElement {
    @api selectedUserId;
    @track selectedBranch = '';
    @track branchOptions = [];
    @track error;

    @wire(getAllInstallBranches)
    wiredallInstallBranches({ error, data }) {
        if (data) {
            for(i=0; i<data.length; i++) {
                this.branchOptions = [...this.branchOptions ,{value: data[i].Id , label: data[i].Name}];                                   
            }     
        } else if (error) {
            this.error = error;
        }
    }
    
    handleChange(event){
        this.selectedBranch = event.detail.value;
        console.log('selectedOption=' + this.selectedBranch);
    }

    submitDetails(event){
        console.log('save called' ,this.selectedUserId);
        saveHomeBranchAssingment({branchId: this.selectedBranch, userId: this.selectedUserId})
        .then(data => {
            const evt = new ShowToastEvent({
                title: 'Success',
                message: 'Home Branch assigned',
                variant: 'success',
            });
            this.dispatchEvent(evt);
            this.error = null;
        })
        .catch(error => {
            this.error = error;
        });
      }
    

    closeModal(event){
        console.log('close modal called');
    }
}