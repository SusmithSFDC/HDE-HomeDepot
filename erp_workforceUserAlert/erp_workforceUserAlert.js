/**
 * Created by SXK2ZTA on 3/30/21.
 */

import {LightningElement, api, wire} from 'lwc';
import {getRecord, getFieldValue} from 'lightning/uiRecordApi';
import reviewTheError from '@salesforce/schema/User_Assignment__c.LMS_User_Master_Validation__c';

const FIELD = ['User_Assignment__c.LMS_User_Master_Validation__c']

export default class ErpWorkforceUserAlert extends LightningElement {

    @api recordId;

    @wire(getRecord, {recordId: '$recordId', fields: FIELD})
    reviewdata;

    get reviewMessage(){
        return getFieldValue(this.reviewdata.data, reviewTheError);
    }

}