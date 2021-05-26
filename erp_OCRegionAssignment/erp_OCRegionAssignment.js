import { LightningElement, api, track, wire} from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';
import getJsonData from '@salesforce/apex/ERP_FlowDuallistboxController.getDivisionRegionData';
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
    @api comboLabel = '';
    @api comboPlaceholder = '';
    @track selectedvalue;
    @track show = false;
    duallistOptions;
    selectedComboValue;
    @api jsonData = [];
    sessionData;
    comboOpt;
    @api selectedOutputRegions = '';
    @api userAssignmentId = '';
    wireData;

    @wire(getJsonData, {lstDivisions : '$comboOpt',userAssignmentRecordId : '$userAssignmentId'})
    wiredRecords({ error, data }) {
        console.log("test Wire: +++");
        if (data) {
            //var wiredata = JSON.parse(JSON.stringify(data));            
            //this.jsonData = JSON.parse(JSON.stringify(data));
            console.log('records++'+JSON.stringify(data)); 
            this.wireData = data;
            this.checkSession(data);          
            this.error = undefined;
        } else if(error){
            console.log('error++'+JSON.stringify(error));
            this.jsonData = undefined;
            this.error = error;
        }
    }

    checkSession(data){
        if(sessionStorage.getItem('jsondata') != '' && sessionStorage.getItem('jsondata') != null && sessionStorage.getItem('jsondata').length > 0){
            var retrieveData = JSON.parse(sessionStorage.getItem('jsondata')); 
            var isFound = false;       
            console.log("retrieveData++"+JSON.stringify(retrieveData)); 
            if(retrieveData.length === data.length){
                for(var i=0;i<retrieveData.length;i++){
                    console.log("data[i]++"+JSON.stringify(data[i]));
                    if(retrieveData[i].divisionName !== data[i].divisionName){
                        isFound = true;
                        break;
                    }
                }
                if(isFound){
                    this.jsonData = JSON.parse(JSON.stringify(data));
                }
                else{
                    this.jsonData = retrieveData;
                }
            }     
            else{
                this.jsonData = JSON.parse(JSON.stringify(data));
            }      
            
        }
        else{
            this.jsonData = JSON.parse(JSON.stringify(data));
        }
    }

    connectedCallback(){
        
        
        //console.log('comboOptions++'+JSON.stringify(this.comboOptions));
        
        /*if(sessionStorage.getItem('jsondata') != '' && sessionStorage.getItem('jsondata') != null && sessionStorage.getItem('jsondata').length > 0){
            var retrieveData = JSON.parse(sessionStorage.getItem('jsondata'));        
            console.log("retrieveData++"+JSON.stringify(retrieveData));            
            this.jsonData = retrieveData;
        }
        else{*/
            this.comboOpt = JSON.stringify(this.divOptions);
        //}
        console.log('rrr++');
        //this.getJson();
    }

    get divOptions(){
        console.log("++"+this.comboOptt);
        var opts = [];
        for(let i of this.comboOptt){
            opts.push(JSON.parse(i));
            console.log("i++"+JSON.parse(i));
        }
        return opts;
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
        //this.selectedOutputRegions = '';
        const unique = (value, index, self) => {
            return self.indexOf(value) === index
        }
        var outputRegionsLabel = [];
        for(let i of e.detail.value){
            console.log("this.duallistOptions++"+JSON.stringify(this.duallistOptions)); 
            var regionLabel = this.duallistOptions.find(data=> data.value === i);
            console.log("regionLabel++"+JSON.stringify(regionLabel));
            if(regionLabel != undefined){
                this.selectedOutputRegions += regionLabel.label +', ';
                outputRegionsLabel.push(regionLabel.label);
            }
        }        
        console.log("jsonData++"+JSON.stringify(this.jsonData)); 
        console.log("this.selectedOutputRegions++"+this.selectedOutputRegions);
        console.log("outputRegionsLabel++"+JSON.stringify(outputRegionsLabel));
        const uniqueOutputLabels = outputRegionsLabel.filter(unique);
        console.log("uniqueOutputLabels++"+uniqueOutputLabels);
        var stringOutput = JSON.stringify(uniqueOutputLabels).replaceAll('"','').replaceAll('[','').replaceAll(']','');
        this.selectedOutputRegions =  stringOutput; 
        
    }

    /*handleRefresh(event){
        console.log("click++");
        for(let i of this.comboOptt){
            opts.push(JSON.parse(i));
            console.log("i++"+JSON.parse(i));
        }
        var opts = [];
        this.divOptions = opts;
        this.comboOpt = JSON.stringify(this.divOptions);
        this.show = false;
    }*/

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
    handleRefresh(event){
                       
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
            this.selectedOutputRegions = '';
            for(let i of regions.selectedRegions){
            
            var regionLabel = this.duallistOptions.find(data=> data.value === i);
            console.log("regionLabel++"+JSON.stringify(regionLabel));
            if(regionLabel != undefined){
                this.selectedOutputRegions += regionLabel.label +', ';
            }
            }        
        console.log("jsonData++"+JSON.stringify(this.jsonData)); 
        console.log("this.selectedOutputRegions++"+this.selectedOutputRegions);
        this.selectedOutputRegions = this.selectedOutputRegions.slice(0, -2);       
            const evt = new ShowToastEvent({
           // title: 'Title',
            message: 'Individual Region priority adjustments will reset to standard overnight.',
            variant: 'warning',
            });
            this.dispatchEvent(evt);
        }
                
        
    }
    
}