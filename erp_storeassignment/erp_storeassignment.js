import { LightningElement, track, api, wire } from 'lwc';
import getStoreProductList from '@salesforce/apex/erp_UserAssignmentCtrl.getStoreProductList';

var mapping = [
    {
      "Id": "0051C000007rFPfQAM",
      "Name": "District - 1",
      "stores":[
          {"Id":"1051C000007rFPfQAM","Name":"0121","isChecked":false,"products":[{"Id":"1","Name":"Windows","isChecked":false},{"Id":"2","Name":"Entry Doors","isDisabled":true,"isChecked":false}]},
          {"Id":"2051C000007rFPfQAM","Name":"0123","isChecked":false,"products":[{"Id":"3","Name":"Windows","isChecked":false},{"Id":"4","Name":"Entry Doors","isDisabled":true,"isChecked":false}]}
      ]
    },
    {
      "Id": "0051C000007rG8VQAU",
      "Name": "District - 2",
      "stores":[
        {"Id":"3051C000007rFPfQAM","Name":"0122","isChecked":false,"products":[{"Id":"5","Name":"Windows","isChecked":false},{"Id":"6","Name":"Entry Doors","isDisabled":true,"isChecked":false}]},
        {"Id":"4051C000007rFPfQAM","Name":"0133","isChecked":false,"products":[{"Id":"7","Name":"Windows","isChecked":false}]}
        ]
    },
    {
      "Id": "0051C000007rG8kQAE",
      "Name": "District - 3",
      "stores":[
        {"Id":"5051C000007rFPfQAM","Name":"0153","isChecked":false,"products":[{"Id":"8","Name":"Windows","isChecked":false}]},
        {"Id":"6051C000007rFPfQAM","Name":"0145","isChecked":false,"products":[{"Id":"9","Name":"Windows","isChecked":false}]}
        ]
    }
  ];
export default class Erp_storeassignment extends LightningElement {
    @api branchId = '';
    @api productIds = [];
    @api selectedStoreProducts = [];
    @track data = mapping;
    @track storeProductList;
    @track error;
    @track dataToDisplay = false;
    @api selectedProducts;
    @api userAssignmentId = '';

    connectedCallback(){
        this.getData();
    }

    //Methid to get data from apex class
    getData(){
        //Calling apex method
        getStoreProductList({ branchId : this.branchId, productIds : this.productIds, userAssignmentId : this.userAssignmentId })
            .then((data) => {
                console.log("data++ "+JSON.stringify(data));
            //Chceking if session storage cotains data , then retreving that data
            if(sessionStorage.getItem('storeAssgndata') != undefined && 
            sessionStorage.getItem('storeAssgndata') != '' && sessionStorage.getItem('storeAssgndata') != null
             && sessionStorage.getItem('storeAssgndata').length > 0)
             {                 
                var wiredata = JSON.parse(JSON.stringify(data));
                var retrievedata = JSON.parse(sessionStorage.getItem('storeAssgndata'));
                var prodids = sessionStorage.getItem('productIds');
                var pids = JSON.stringify(this.productIds);
                var isDiffer = false;
                //Using condition to check if session storage data is old or user selected different product
                if(retrievedata.length === wiredata.length && pids === prodids){
                    for(var i=0;i<retrievedata.length;i++){
                        if(retrievedata[i].id === wiredata[i].id){

                        }
                        else{
                            isDiffer = true;
                            break;
                        }
                    }
                    //If data is different then updating with apex class records
                    if(isDiffer){
                        this.updateWireData(JSON.parse(JSON.stringify(data)));
                    }
                    //Else if product or data is same then updating it from session records.
                    else{
                        this.updateSessionData();
                    }
                } 
                //If session data is not same as apex data or product is different then updating with apex records.
                else{
                    this.updateWireData(JSON.parse(JSON.stringify(data)));
                }

            }
            //If session storage is null, then updating with apex records.
            else{
                this.updateWireData(JSON.parse(JSON.stringify(data)));
            }
                this.error = undefined;
            })
            .catch((error) => {
                this.error = error;
                
            });
    }
    
    updateWireData(records){
        this.storeProductList = records;
        console.log("StoreProduct LIst: ++",records);
        this.selectedStoreProducts = this.storeProductList;
        this.selectedProducts = JSON.stringify(this.selectedStoreProducts);        
        if(this.storeProductList.length > 0){
            this.dataToDisplay = true;
        }
    }
    
    updateSessionData(){
        this.storeProductList = JSON.parse(sessionStorage.getItem('storeAssgndata'));
        this.selectedStoreProducts = this.storeProductList;
        this.selectedProducts = JSON.stringify(this.selectedStoreProducts);        
        if(this.storeProductList.length > 0){
            this.dataToDisplay = true;
        }
    }

    handleDistrictChange(event) {
        var checkBoxFieldValue = event.target.checked
        var numberFieldValue = event.target.value;
    
        for (var i = 0; i < this.storeProductList.length; i++) {
            var district = this.storeProductList[i];
            if (district.id === numberFieldValue) {
                district.isChecked = checkBoxFieldValue;
                district.showDistrict = checkBoxFieldValue;
                for (var j = 0; j < district.stores.length; j++) {
                    district.stores[j].isChecked = checkBoxFieldValue;
                    for (var k = 0; k < district.stores[j].products.length; k++) {
                        district.stores[j].products[k].isChecked = checkBoxFieldValue;
                    }
                }
            }
        }
        this.selectedStoreProducts = [...this.storeProductList];
        this.selectedProducts = JSON.stringify(this.selectedStoreProducts);
    }

    handleProductChange(event) {
        var checkBoxFieldValue = event.target.checked;
        var numberFieldValue = event.target.value;
        var district = event.currentTarget.dataset.id;
        var store = event.currentTarget.dataset.value;
        var family = event.currentTarget.dataset.name;
        var isDiffer = false;
        console.log("checkBoxFieldValue++"+checkBoxFieldValue);
        console.log("numberFieldValue++"+numberFieldValue);
        console.log("district++"+district);
        console.log("store++"+store);
        console.log("fmaily++"+family);
        for (var i = 0; i < this.storeProductList.length; i++) {
            for (var j = 0; j < this.storeProductList[i].stores.length; j++) {
                for (var k = 0; k < this.storeProductList[i].stores[j].products.length; k++) {
                    if (this.storeProductList[i].stores[j].products[k].uniqueId === numberFieldValue) {
                        this.storeProductList[i].stores[j].products[k].isChecked = checkBoxFieldValue;
                    }
                }
                //check if any one product is checked, check store
                for (var k = 0; k < this.storeProductList[i].stores[j].products.length; k++) {
                    if (this.storeProductList[i].stores[j].products[k].isChecked) {
                        this.storeProductList[i].stores[j].isChecked = true;
                        break; //check the store and break the loop
                    }
                    this.storeProductList[i].stores[j].isChecked = false;
                }
            }
        }
        if (this.storeProductList[district].userRole === 'District Installation Manager' &&
            family === 'HDE') {
            for (var i = 0; i < this.storeProductList[district].stores[store].products.length; i++) {
                if (this.storeProductList[district].stores[store].products[i].family === 'HDE') {
                    this.storeProductList[district].stores[store].products[i].isChecked = checkBoxFieldValue;
                }
            }
        }
        if (!checkBoxFieldValue) {
            var storesUnchecked = [];
            this.storeProductList[district].isChecked = checkBoxFieldValue;
            for (var i = 0; i < this.storeProductList[district].stores.length; i++) {
                if (this.storeProductList[district].stores[i].isChecked) {
                    var isDifferProduct = false;
                    for (var j = 0; j < this.storeProductList[district].stores[i].products.length; j++) {
                        if (this.storeProductList[district].stores[i].products[j].isChecked) {
                            isDifferProduct = true;
                            break;
                        }
                    }
                    if (!isDifferProduct) {
                        this.storeProductList[district].stores[i].isChecked = checkBoxFieldValue;
                        storesUnchecked.push(this.storeProductList[district].stores[i].id);
                    }
                } else {
                    storesUnchecked.push(this.storeProductList[district].stores[i].id);
                }
            }
            // If all stores are unchecked , then hide district
            if (storesUnchecked.length > 0 &&
                storesUnchecked.length === this.storeProductList[district].stores.length) {
                this.storeProductList[district].showDistrict = checkBoxFieldValue;
            }
        } else {
            this.storeProductList[district].showDistrict = checkBoxFieldValue;
            for (var i = 0; i < this.storeProductList[district].stores.length; i++) { 
                // running the loop to check if all the products are uncheck then making the store uncheck 
                if (this.storeProductList[district].stores[i].isChecked) {
                    for (var j = 0; j < this.storeProductList[district].stores[i].products.length; j++) {
                        if (!this.storeProductList[district].stores[i].products[j].isChecked) {
                            isDiffer = true;
                            break;
                        }
                    }
                } else {
                    isDiffer = true;
                    break;
                }
            }
            if (!isDiffer) {
                this.storeProductList[district].isChecked = checkBoxFieldValue;
            }
        }
        this.selectedStoreProducts = [...this.storeProductList];
        this.selectedProducts = JSON.stringify(this.selectedStoreProducts);
    }

    handleStoreChange(event) {
        var checkBoxFieldValue = event.target.checked;
        var numberFieldValue = event.target.value;
        var districtId = event.currentTarget.dataset.id;
        for (var i = 0; i < this.storeProductList.length; i++) {
            var storeIdsChecked = [];
            var storeIdsUnchecked = [];
            for (var j = 0; j < this.storeProductList[i].stores.length; j++) {
                if (this.storeProductList[i].stores[j].id === numberFieldValue) {
                    this.storeProductList[i].stores[j].isChecked = checkBoxFieldValue;
                    for (var k = 0; k < this.storeProductList[i].stores[j].products.length; k++) {
                        this.storeProductList[i].stores[j].products[k].isChecked = checkBoxFieldValue;
                    }
                }
                if (this.storeProductList[i].id === districtId) {
                    if (this.storeProductList[i].stores[j].isChecked) {
                        storeIdsChecked.push(this.storeProductList[i].stores[j].id);
                    } else {
                        storeIdsUnchecked.push(this.storeProductList[i].stores[j].id);
                    }
                    if (checkBoxFieldValue) {
                        this.storeProductList[i].showDistrict = checkBoxFieldValue;
                    }
                }
                //break;//no need to iterate over other stores
            }
            if ((storeIdsChecked.length > 0 || storeIdsUnchecked.length > 0) && (storeIdsChecked.length === this.storeProductList[i].stores.length ||
                    storeIdsUnchecked.length === this.storeProductList[i].stores.length)) {
               
                this.storeProductList[i].isChecked = checkBoxFieldValue;
            }
            // showing the district name on the confirmation screen if one store is selcted with out any disctrict 
            if (!checkBoxFieldValue && this.storeProductList[i].id === districtId) {
                
                this.storeProductList[i].isChecked = checkBoxFieldValue;
                //If all stores unchecked ,then hide district
                if (storeIdsUnchecked.length > 0 && storeIdsUnchecked.length === this.storeProductList[i].stores.length) {
                    
                    this.storeProductList[i].showDistrict = checkBoxFieldValue;
                } else {
                    
                    this.storeProductList[i].showDistrict = true;
                }
            }
        }
        this.selectedStoreProducts = [...this.storeProductList];
        this.selectedProducts = JSON.stringify(this.selectedStoreProducts);
    }

    handleArrow(event){
        var dataid = event.target.dataset.id;                        
        if(this.template.querySelector('lightning-button-icon[data-id="'+dataid+'"]').iconName === 'utility:chevrondown'){
            this.template.querySelector('lightning-button-icon[data-id="'+dataid+'"]').iconName = 'utility:chevronup';
            this.template.querySelector('div[data-id="'+dataid+'"]').className = 'slds-show';
        }
        else if(this.template.querySelector('lightning-button-icon[data-id="'+dataid+'"]').iconName === 'utility:chevronup'){
            this.template.querySelector('lightning-button-icon[data-id="'+dataid+'"]').iconName = 'utility:chevrondown';
            this.template.querySelector('div[data-id="'+dataid+'"]').className = 'slds-hide';
        }
    }

    @api
    validate() {
        sessionStorage.setItem('storeAssgndata',JSON.stringify(this.selectedStoreProducts));
        sessionStorage.setItem('productIds',JSON.stringify(this.productIds));
        return { isValid: true };
    }
}