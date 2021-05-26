import { LightningElement , api , wire , track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import HOA_Required_FIELD from '@salesforce/schema/Customer_Order__c.HOA_Required__c';
import Credit_Hold_FIELD from  '@salesforce/schema/Customer_Order__c.Credit_Hold__c';
import Arch_Review_FIELD from   '@salesforce/schema/Customer_Order__c.ArchReview_Required__c';
import SPL_FINANCE_FIELD from   '@salesforce/schema/Customer_Order__c.Special_Finance_Flag__c';
//import SALES_Cred_Hold_FIELD from '@salesforce/schema/gii__SalesOrder__c.CustomerOrder__r.Credit_Hold__c';
//import SALES_HO_Required_FIELD from '@salesforce/schema/gii__SalesOrder__c.CustomerOrder__r.HOA_Required__c';
import ARCH from   '@salesforce/schema/gii__SalesOrder__c.Customer_Order__r.ArchReview_Required__c';
import HOA from   '@salesforce/schema/gii__SalesOrder__c.Customer_Order__r.HOA_Required__c';
import CREDIT from   '@salesforce/schema/gii__SalesOrder__c.Customer_Order__r.Credit_Hold__c';
import SPLFINANCE from   '@salesforce/schema/gii__SalesOrder__c.Customer_Order__r.Special_Finance_Flag__c';



export default class Erp_JobSpecialFinance extends LightningElement {
    @api recordId;
    @api objectApiName;
    @track holdValue = '';
    @track specialFinance = '';
    fields = '';
    @wire(getRecord, { recordId: '$recordId', fields: '$fields'})
    customerOrder({
        data,error
    }){
        if(data){
            console.log("data+"+JSON.stringify(data));
            //console.log("value+"+data.fields.Credit_Hold__c.value);
            this.holdValue = '';
            if(this.objectApiName === 'Customer_Order__c'){
                if(data.fields.Credit_Hold__c.value){
                    this.holdValue += 'Credit Hold, ';
                }   
                if(data.fields.HOA_Required__c.value){
                    this.holdValue += 'HOA Hold, ';
                }
                if(data.fields.ArchReview_Required__c.value){
                    this.holdValue += 'Architecture Hold, ';
                }
                this.holdValue = this.holdValue.slice(0, -2);

                if(data.fields.Special_Finance_Flag__c.value != '' && data.fields.Special_Finance_Flag__c.value != null){
                    this.specialFinance = data.fields.Special_Finance_Flag__c.value;
                }   
            }  
            else{
                console.log("--"+JSON.stringify(data.fields));
                console.log("-2-"+data.fields);
                console.log("--3-"+JSON.stringify(data.fields.Customer_Order__r));
                //console.log("---"+JSON.stringify(data.fields[0]));
                console.log("---"+JSON.stringify(data.fields.Customer_Order__r.value));
                console.log("---"+JSON.stringify(data.fields.Customer_Order__r.value.fields));
                if(data.fields.Customer_Order__r.value.fields.Credit_Hold__c.value){
                    this.holdValue += 'Credit Hold, ';
                }
                if(data.fields.Customer_Order__r.value.fields.HOA_Required__c.value){
                    this.holdValue += 'HOA Hold, ';
                }
                if(data.fields.Customer_Order__r.value.fields.ArchReview_Required__c.value){
                    this.holdValue += 'Architecture Hold, ';
                }
                this.holdValue = this.holdValue.slice(0, -2);

                if(data.fields.Customer_Order__r.value.fields.Special_Finance_Flag__c.value != '' && data.fields.Customer_Order__r.value.fields.Special_Finance_Flag__c.value != null){
                    this.specialFinance = data.fields.Customer_Order__r.value.fields.Special_Finance_Flag__c.value;
                }
            }
            }
        if(error){
            console.log("error+"+error);
        }
    }
    connectedCallback() {
        console.log("objectApiName++"+this.objectApiName);
        console.log("recordid+"+this.recordId);
        console.log("++"+this.customerOrder.data);
        
        if(this.objectApiName === 'Customer_Order__c'){
            this.fields =  [HOA_Required_FIELD, Credit_Hold_FIELD, Arch_Review_FIELD, SPL_FINANCE_FIELD];
        }
        else if(this.objectApiName === 'gii__SalesOrder__c'){
            this.fields = [CREDIT, ARCH, HOA , SPLFINANCE];
        }
    }
}