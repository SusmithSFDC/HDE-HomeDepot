import { LightningElement, api, track, wire } from 'lwc';
import getSkills from '@salesforce/apex/HDEERP_UserAssignmentCtrl.getSkills';
import saveProductAssignment from '@salesforce/apex/HDEERP_UserAssignmentCtrl.saveProductAssignment';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

let i=0;
export default class Erp_productassignment extends LightningElement {
    @api selectedUserId;
    @track _selected = []; // this array tracks the seleted values
    @track productOptions =[];
    @track selectedProducts =[];

    
    @wire(getSkills, { category:'ERP', subCategory:'Products' })
    wiredGetSkills({ error, data }) {
        if (data) {
            console.log('data -->' ,data);
            for(i=0; i<data.length; i++) {
                this.productOptions = [...this.productOptions ,{value: data[i].Id , label: data[i].Name}];                                   
            }     
        } else if (error) {
            this.error = error;
        }
    }
    
    handleChange(event){
        this.selectedProducts = event.detail.value;
        this._selected = event.detail.value;
        console.log('selectedOption=' + this._selected);
    }

    submitDetails(event){
        console.log('save called' ,this._selected);
        saveProductAssignment({productSkills: this.selectedProducts, userId: this.selectedUserId})
        .then(data => {
            const evt = new ShowToastEvent({
                title: 'Success',
                message: 'Products assigned',
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