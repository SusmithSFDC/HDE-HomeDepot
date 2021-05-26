import {LightningElement,api} from 'lwc';

export default class Erp_VerifyTaskSummary extends LightningElement {
	@api taskJSON;
	get taskRecords() {
		var records = JSON.parse(this.taskJSON);
		for (let i of records) {
			if (i.isChecked) {
				i.selectedProducts = '';
				for (let j of i.products) {
					if (j.isChecked) {
						i.selectedProducts += j.name + ' ' + j.abbreviation + ', ';
					}
				}
				i.selectedProducts = i.selectedProducts.slice(0, -2);
			}
		}
			
		return records;
	}
}