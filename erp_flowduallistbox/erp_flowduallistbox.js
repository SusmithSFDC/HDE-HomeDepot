import { LightningElement,track,api } from 'lwc';

export default class Erp_flowduallistbox extends LightningElement {

_selected = [];    
@api lblValue = '';
@api availableOptions = [];
@api selectedValuesJSON =[];
@api selectedValuesLabel = '';
@api sourceLabel = '';
@api selectedLabel = '';
@api leftNote = '';
@api rightNote = '';
@api defaultValue = [];
@api isEmptySelectedValues = false;
get options(){
    var opts = [];
    /*for(let i of this.availableOptions){
        opts.push(JSON.parse(i));
    }*/        
    return JSON.parse(this.availableOptions);
}

connectedCallback() {
    console.log("this.defaultValue++"+this.defaultValue);
    console.log("connectedCallback is called");
    console.log("selectedValuesLabel --> " +this.selectedValuesLabel);
    console.log("selectedValuesJSON --> " +this.selectedValuesJSON);
    console.log("isEmptySelectedValues --> " +this.isEmptySelectedValues);
    //console.log("selectedValuesJSON+++ "+selectedValuesJSON);

    if(this.selectedValuesJSON != '' && this.selectedValuesJSON.length > 0){
        var selectedValues = [];
        this.defaultValue = [];
        console.log("if1");
        for (let i of this.selectedValuesJSON) {       
            var obj = JSON.parse(i);
            /*const result = this.options.find(data => data.value === i);
            console.log("result++"+JSON.stringify(result));*/
            selectedValues.push(JSON.stringify(obj));
            this.selectedValuesLabel += obj.label + ', ';
            this.defaultValue.push(obj.value);
        }
        this.selectedValuesLabel = this.selectedValuesLabel.slice(0, -2);
        
        console.log("selectedValues++"+JSON.stringify(selectedValues));

        this.selectedValuesJSON = selectedValues;
    }
    else if(!this.isEmptySelectedValues && this.defaultValue != undefined && this.defaultValue.length > 0){
        var selectedValues = [];

        for (let i of this.defaultValue) {       
            const result = this.options.find(data => data.value === i);
            selectedValues.push(JSON.stringify(result));
            this.selectedValuesLabel += result.label + ', ';
        }
        this.selectedValuesLabel = this.selectedValuesLabel.slice(0, -2);
        
        console.log("selectedValues++"+JSON.stringify(selectedValues));

        this.selectedValuesJSON = selectedValues;
    }
    if(this.isEmptySelectedValues){
        this.defaultValue = [];
    }
}

@api
get selected() {

    return this._selected.length ? this._selected : 'none';
}


handleChange(e) {
    this._selected = e.target.value;
    this.selectedValuesLabel = '';
    this.isEmptySelectedValues = false;
    console.log("selectede.detail++"+this._selected);
    var selectedValues = [];
    for (let i of this._selected) {       
        const result = this.options.find(data => data.value === i);
        selectedValues.push(JSON.stringify(result));
        this.selectedValuesLabel += result.label + ', ';
    }
    this.selectedValuesLabel = this.selectedValuesLabel.slice(0, -2);
    console.log("selectede.detail++"+this._selected);
    console.log("e.detail.value++"+e.detail.value);   
    console.log("selectedValues++"+JSON.stringify(selectedValues));
    if(selectedValues.length == 0){
        this.isEmptySelectedValues = true;
    }
    this.selectedValuesJSON = selectedValues;
    //this.selectedDivision = e.target.value;
}
}