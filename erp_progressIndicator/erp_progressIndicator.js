import {LightningElement, api, track} from 'lwc';

export default class ErpProgressIndicator extends LightningElement {

    @api currentStage = ''
    @api stages = []


    @api
    get showStages() {
        return (this.stages.length > 0 && this.currentStage.length > 0);
    }

}