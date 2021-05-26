/**
 * Created by SXK2ZTA on 4/15/21.
 */

import {LightningElement, wire, api} from 'lwc';
import getData from '@salesforce/apex/erp_TaskOverview.getData';
import getFieldsInfo from '@salesforce/apex/erp_TaskOverview.getFieldsInfo';

export default class ErpTaskOverview extends LightningElement {

    @api ObjectAPIName;
    @api Fields;
    results;
    sortBy;
    sortDirection;
    columns;
    isLoaded = true;

    @wire(getData, {objectName:'$ObjectAPIName', fields: '$Fields'})
    allData({data, error}) {
        if(data){
            console.log('data '+JSON.stringify(data));
            let newData = [];
            data.forEach(ele => {
                let newD = {...ele};
                if(newD['Subject']){
                    newD.SubjectURL = '/lightning/r/'+this.ObjectAPIName+'/'+ele.Id+'/view';
                }
                if(newD['Job_Number__c']){
                    newD.jobNumberURL = '/lightning/r/'+this.ObjectAPIName+'/'+ele.Id+'/view';
                }
                newData.push(newD);
            });
            this.results = [...newData];
            this.isLoaded = false;
        }
        else if(error) {
            this.results = undefined;
            this.isLoaded = false;
        }
    }

    @wire(getFieldsInfo, {objectName:'$ObjectAPIName', fields: '$Fields'})
    getFieldsInfoWired({data, error}) {
        if(data){
            console.log('getFieldsInfo '+data);
            let flds = this.Fields.split(',');
            this.columns = [];
            flds.forEach(ele => {
                let type = (ele == 'Job_Number__c' || ele == 'Subject') ? 'url' : 'text';
                let col = {
                    label : data[ele].label,
                    fieldName: ele+(type=='url' ? 'URL' : ''),
                    type: type,
                    sortable: 'true'
                }
                if(type == 'url'){
                    col.typeAttributes = {
                        label: {fieldName: ele}
                    }
                }
                this.columns = [...this.columns,col];
            });
            console.log('Columns: '+JSON.stringify(this.columns));
        }
        else if(error) {
            this.results = undefined;
        }
    }

    connectedCallback(){
        getFieldsInfo({objectName:'$ObjectAPIName', fields: '$Fields'})
            .then( res => {
                let flds = this.Fields.split(',');
                this.columns = [];
                flds.forEach(ele => {
                    let type = (ele == 'Job_Number__c' || ele == 'Subject') ? 'url' : 'text';
                    let col = {
                        label : res[ele].label,
                        fieldName: ele+(type=='url' ? 'URL' : ''),
                        type: type,
                        sortable: 'true'
                    }
                    if(type == 'url'){
                        col.typeAttributes = {
                            label: {fieldName: ele}
                        }
                    }
                    this.columns = [...this.columns,col];
                });
                console.log('Columns: '+this.columns);
            })
            .catch(err => console.log('error: '+ JSON.stringify(err)));
    }

    sortColumns(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.results));

        let keyValue = (a) => { //Return the value stored in the field
            return a[fieldname];
        };

        let isReverse = direction === 'asc' ? 1: -1;

        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; //handling null values
            y = keyValue(y) ? keyValue(y) : '';

            return isReverse * ((x > y) - (y > x)); // sorting values based on direction

        });

        this.results = parseData;
    }

}