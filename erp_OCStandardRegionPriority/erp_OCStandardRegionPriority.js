import { LightningElement, api, track, wire} from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';
import getJsonData from '@salesforce/apex/ERP_FlowDuallistboxController.getStandardDivisionRegionData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class ComboboxBasic extends LightningElement {
    @api
    availableActions = [];
    value = '';
    @track selectedreg = [];
    @api tolltip = '';
    @api lblValue = '';
    comboOptions=[];
    @api comboOptt=[];   
    @api comboLabel = 'Select Division';
    @api comboPlaceholder = '';
    @track selectedvalue;
    @track show = false;
    @track duallistOptions;
    selectedComboValue;
    @api jsonData = [];
    sessionData;
    comboOpt;
    @api selectedOutputRegions = '';
    @api userAssignmentId = '';
    divOptions;wireData;

    @wire(getJsonData, {userAssignmentRecordId : '$userAssignmentId'})
    wiredRecords({ error, data }) {
        console.log("test Wire: +++");
        if (data) {
            //var wiredata = JSON.parse(JSON.stringify(data));            
            //this.jsonData = JSON.parse(JSON.stringify(data));            
            console.log("jsonData++"+this.jsonData);
            console.log('records++'+JSON.stringify(data));  
            if(this.jsonData != '' && this.jsonData != undefined){
                this.jsonData = JSON.parse(this.jsonData);
                this.divOptions = this.jsonData[0].availableDivisions;
            }
            else{
                this.jsonData = JSON.parse(JSON.stringify(data));
                this.divOptions = data[0].availableDivisions;
            }
            this.wireData = JSON.parse(JSON.stringify(data));
            
            this.error = undefined;
        } else if(error){
            console.log('error++'+JSON.stringify(error));
            this.jsonData = undefined;
            this.error = error;
        }
    }

    
    handleComboChange(event) {
        console.log("event++"+JSON.stringify(event.detail));
        console.log("divOptions++"+this.divOptions);
        var selected = this.divOptions.find(data=> data.value === event.detail.value);
        this.selectedvalue = selected.label;
        this.selectedComboValue = selected.value;
        var regions = this.jsonData.find(data=> data.divisionName === this.selectedvalue);
        if(regions != undefined){
            console.log("regions++"+JSON.stringify(regions));
            console.log("regions.availableRegions++"+JSON.stringify(regions.availableRegions));
            console.log("regions.selectedRegions++"+JSON.stringify(regions.selectedRegions));
            this.duallistOptions = regions.availableRegions;
            this.show = true;
            if(regions.selectedRegions != null && regions.selectedRegions.length>0){
                console.log("inside");
                this.selectedreg = regions.selectedRegions;
            }
        }
        else{
            this.duallistOptions = '';
            this.show = false;
        }
        
    }       

    handleDuallistChange(e) {
        //this._selected = e.detail.value;
        console.log("json1++"+e.detail.value);
        this.selectedreg = e.detail.value;
        var localjson = this.jsonData;                
        for(var i=0;i<localjson.length;i++){
            if(localjson[i].divisionName === this.selectedvalue){                                
                this.jsonData[i].selectedRegions = e.detail.value;   
                console.log("this.jsonData[i]++"+this.jsonData[i]);             
            }
        }
    }

    handleRefresh(event){
        console.log("click++"+this.comboOptt);
        //this.selectedreg = [];                             
        if(this.selectedvalue != '' && this.selectedvalue != null){
            var regions = this.wireData.find(data=> data.divisionName === this.selectedvalue);
            if(regions != undefined){
                console.log("+regions++"+JSON.stringify(regions));
                console.log("regions.selectedRegions++"+JSON.stringify(regions.selectedRegions));  
                console.log("this.selectedreg+1+"+JSON.stringify(this.selectedreg));  
                this.selectedreg = regions.selectedRegions; 
                console.log("this.selectedreg+2+"+JSON.stringify(this.selectedreg));  
                             
            }
            for(var i=0;i<this.jsonData.length;i++){
                if(this.jsonData[i].divisionName === this.selectedvalue){                                
                    this.jsonData[i].selectedRegions = regions.selectedRegions;   
                    console.log("this.jsonData[i]++"+this.jsonData[i]);             
                }
            }
            /*const evt = new ShowToastEvent({
           // title: 'Title',
            message: 'Individual Region priority adjustments will reset to standard overnight.',
            variant: 'warning',
            });
            this.dispatchEvent(evt);*/
        }
                
        
    }

    @api
    validate() {
        var isBlank = false;
        var divisionNames = '';
        console.log("vali++"+this.jsonData);
        for(var i=0;i<this.jsonData.length;i++){
            if(this.jsonData[i].selectedRegions.length > 0){
                                
            }
            else{
                isBlank = true;
                if(divisionNames === ''){
                    divisionNames  += this.jsonData[i].divisionName;
                }
                else{
                    divisionNames  += ", " + this.jsonData[i].divisionName;
                }
                
            }
        }    
            if(isBlank){
                sessionStorage.setItem('jsondata',JSON.stringify(this.jsonData));
                this.jsonData = JSON.stringify(this.jsonData);
                return { 
                    isValid: false, 
                    errorMessage:  'Please select regions for these divisions:' +divisionNames 
                };
            }
            else{  
                sessionStorage.setItem('jsondata','');              
                sessionStorage.setItem('jsondata',JSON.stringify(this.jsonData)); 
                console.log("retrieveData2++"+JSON.stringify(sessionStorage.getItem('jsondata'))); 
                this.jsonData = JSON.stringify(this.jsonData);
                return { isValid: true };
            }
                            
    }

    
}