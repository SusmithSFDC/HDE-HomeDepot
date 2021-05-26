import { LightningElement,api,track } from 'lwc';

export default class Erp_userassingment extends LightningElement {
    @track showFooter = false;
    @api selectedUserRole;
    @api selectedUserName;
    @api selectedUserId;

    closeModal() {
        const selectedEvent = new CustomEvent("modalclose", {
            flag: false
        });
        this.dispatchEvent(selectedEvent);
    }
}