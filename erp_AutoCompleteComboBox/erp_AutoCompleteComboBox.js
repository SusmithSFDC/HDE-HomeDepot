import { LightningElement,api } from 'lwc';
//import getAllInstallBranches from '@salesforce/apex/erp_AutoCompleteComboBoxCtrl.getAllInstallBranches';
export default class Erp_AutoCompleteComboBox extends LightningElement {

    //values;//=[{key:'Branch1',value:'Branch1'},{key:'Branch2',value:'Branch2'},{key:'Branch3',value:'Branch3'},{key:'Branch4',value:'Branch4'}];
    @api options;
    @api label = '';
    @api name = '';
    @api value = '';
    @api required;
    @api placeholder = "Search by Branch Name";
    @api selectedBranch = '';
    initialized = false;

    renderedCallback() {
        if (this.initialized) {
            return;
        }
        this.initialized = true;
        let listId = this.template.querySelector('datalist').id;
        this.template.querySelector("input").setAttribute("list", listId);
        var opt = JSON.parse(this.options);
        var optLabel = opt.find(data=> data.value === this.value);
        this.selectedBranch = optLabel !== undefined ? optLabel.label : '';
    }

    handleChange(event) {
        console.log("value++"+event.target.value);
        if(event.target.value !== undefined && event.target.value !== null && event.target.value !== ''){ 
        var opt = JSON.parse(this.options);
        var optValue = opt.find(data=> data.label === event.target.value);
        this.value = optValue.value;
        this.selectedBranch = event.target.value;
        /*console.log("value++"+value);
        this.dispatchEvent(new CustomEvent('change', { bubbles: false, detail: { value: evt.target.value, target: this.name } }));
        */
        }
        else{
            this.value = '';
            this.selectedBranch = '';
        }
    }

    get values(){
        return JSON.parse(this.options);
    }

    get inputValue(){
        var opt = JSON.parse(this.options);
        var optLabel = opt.find(data=> data.value === this.value);
        return optLabel !== undefined ? optLabel.label : '';

    }

    @api
    validate(){
        console.log("validatevalue++"+this.value);
        if(this.value !== undefined && this.value !== '' && this.value.length > 0){
            return{isValid: true};
        }
        else{
            return{
                isValid: false,
                errorMessage: 'Please select the branch.'
            };
        }
    }
    
}