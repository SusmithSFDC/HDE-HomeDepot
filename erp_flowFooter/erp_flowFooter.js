import { LightningElement, api } from 'lwc';
import { FlowNavigationNextEvent, FlowNavigationBackEvent } from 'lightning/flowSupport';

export default class Erp_flowFooter extends LightningElement {

    @api availableActions = [];
    @api isLastScreen = false;
    @api isFirstScreen = false;
    @api currentStage = '';
    @api stages = [];
    
    handleNext() {
        // check if NEXT is allowed on this screen
        if (this.availableActions.find(action => action === 'NEXT')) {
            // navigate to the next screen
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
        if(this.isLastScreen){            
            sessionStorage.setItem('storeAssgndata',''); 
            sessionStorage.setItem('taskJson', '');
            sessionStorage.setItem('taskProducts', '');
        }
        
    }

    handlePrevious() {
        // check if Previous is allowed on this screen
        if (this.availableActions.find(action => action === 'BACK')) {
            const navigateBackEvent = new FlowNavigationBackEvent();
            this.dispatchEvent(navigateBackEvent);
        }
    }


}