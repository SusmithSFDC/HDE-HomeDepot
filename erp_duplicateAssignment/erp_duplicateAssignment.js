import {LightningElement, api, wire} from 'lwc';


export default class ErpDuplicateAssignment extends LightningElement {

    @api getDuplicates = '';
    data = [];

    get duplicateAssignment() {
        this.data = JSON.parse(this.getDuplicates);
        if(this.data) {
            for(var i = 0; i < this.data.length; i++){
                 // Preventing unexcepted data
                 this.data[i].storeProductMap = [];
                for(let key in this.data[i].storeProducts) {
                    var products = [];//key is store name
                    for(var k = 0 ; k < this.data[i].storeProducts[key].length; k++){
                        products.push(this.data[i].storeProducts[key][k].productName);
                    }
                    var productNames = products.join(', ');
                    console.log(productNames);
                    this.data[i].storeProductMap.push({value:productNames, key:key});
                }

                
            }

            }

        console.log(this.data);
        return this.data;

    }

}