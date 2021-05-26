import {LightningElement, api} from 'lwc';
import { FlowNavigationNextEvent, FlowNavigationBackEvent, FlowNavigationFinishEvent } from 'lightning/flowSupport';

export default class ErpIndicatorFooter extends LightningElement {
    
    /**** Footer * Next and Previous buttons with progress Indicator ****/
    
    @api availableActions = []
    @api showNext = false
    @api showPrevious = false
    @api stages = []
    @api currentStage = ''
    @api labelNext = 'Next'
    @api labelPrevious = 'Previous'

    get showStages() {
        return (this.stages.length > 0 && this.currentStage.length > 0);
    }

    handleNext() {
        if(this.availableActions.find(action => action === 'NEXT')) {
            this.dispatchEvent(new FlowNavigationNextEvent());
        }
    }

    handleBack() {
        if (this.availableActions.find(action => action === 'BACK')) {
            this.dispatchEvent(new FlowNavigationBackEvent());
        }
    }

}