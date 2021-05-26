import { LightningElement, api } from 'lwc';

export default class Erp_verifySelection extends LightningElement {
    @api districtJson;
    
    get districtRecords(){

        var districtRecords = JSON.parse(this.districtJson);
        for (let i of districtRecords) {
			for(let j of i.stores){
                j.selectedProducts = '';
                for(let k of j.products){
                    if(k.isChecked){
                        j.selectedProducts += k.name +', ';
                    }
                }
                j.selectedProducts = j.selectedProducts.slice(0, -2);

            }

		}
        return districtRecords;
    }
    

}