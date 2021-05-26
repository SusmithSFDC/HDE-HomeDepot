import {LightningElement, wire, track} from 'lwc';
import getData from '@salesforce/apex/erp_ListViewCtrl.getData';
import getListViewOptions from '@salesforce/apex/erp_ListViewCtrl.getListViewOptions';

export default class ErpListView extends LightningElement {

    isLoaded = true;
    @track isExpanded = false;
    listViewConfigId;
    records;
    columns;
    sortBy;
    sortDirection;
    listViews = {
        options: [],
        value: ''
    }

    async connectedCallback(){
        let options = await getListViewOptions();
        this.listViews.options = [];
        for(let option of options){
            this.listViews.options.push({
                label: option.Name,
                value: option.Id
            });
        }
        this.listViews.value = this.listViews.options[2].label;
        this.listViewConfigId = this.listViews.options[2].value;

        console.log('this.listViews.value ' + this.listViews.value);
        console.log('this.listViewConfigId ' + this.listViewConfigId);
    }

    handleChange(event){
        this.listViews.value  =  event.detail.value;
        if(this.listViews.value){
            this.listViewConfigId = this.listViews.value
        }
    }


    @wire(getData, {listViewConfigId: '$listViewConfigId'})
    alldata({data, error}) {
        if(data) {
            this.records = data.records;
            this.columns = data.columns;
            this.isLoaded = false;
            console.log('this.records ', this.records);
            console.log('this.columns ',  this.columns);
            console.log('data ' + JSON.stringify(data));
        }
        else if(error) {
            this.records = undefined;
            this.columns = undefined;
            this.isLoaded = false;
        }
    }

    get dropdownTriggerClass() {
        if (this.isExpanded) {
            return 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click custom_list_view slds-is-open'
        } else {
            return 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click custom_list_view'
        }
    }

    handleClickExtend() {
        this.isExpanded = !this.isExpanded;
    }

    handleFilterChangeButton(event) {
        let parentDiv = event.target.closest('div.slds-media').dataset;
        let filter = parentDiv.filter;
        let label = parentDiv.label;
        this.isExpanded = !this.isExpanded;
        console.log('Parent div ', parentDiv)
        console.log('parentDiv.filter ' + parentDiv.filter)
        console.log('parentDiv.label ' + parentDiv.label)
        if (label !== this.listViews.value) {
            this.listViews.value = label;
            this.listViewConfigId = filter;
            this.isLoaded = true;
        }
    }

    sortColumns(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
        console.log('sortBy ', this.sortBy);
    }

    sortData(fieldname, direction){
        let parseData = JSON.parse(JSON.stringify(this.records));

        let keyValue = (a) => {
            return a[fieldname];
        };

        let isReverse = direction === 'asc' ? 1: -1;

        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';
            y = keyValue(y) ? keyValue(y) : '';

            return isReverse * ((x > y) - (y > x));
        });
        this.records = parseData;
    }


}