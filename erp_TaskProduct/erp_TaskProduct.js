import {
	LightningElement,
	track,
	api
} from 'lwc';
import getTaskProductsList from '@salesforce/apex/erp_TaskProductsCtrl.getTaskProducts';
export default class Erp_TaskProduct extends LightningElement {
	@track lstTask = [];
	@api productIds = [];
	@api userAssignmentId = '';
	@api selectedTasks = '';
	connectedCallback() {
		this.getData();
	}
	//Method to get the data from apex..
	getData() {
		getTaskProductsList({
			productIds: this.productIds,
			userAssignmentId: this.userAssignmentId
		}).then((data) => {
			console.log("sessionStorage.getItem('taskJson')++++"+sessionStorage.getItem('taskJson'));
			console.log("getDataTaskProduct++++"+JSON.stringify(data));
			if (sessionStorage.getItem('taskJson') != undefined && sessionStorage.getItem('taskJson') != '' && sessionStorage.getItem('taskJson') != null && sessionStorage.getItem('taskJson').length > 0) {
				
				var wiredata = JSON.parse(data);
				var retrievedata = JSON.parse(sessionStorage.getItem('taskJson'));
				var prodids = sessionStorage.getItem('taskProducts');
				var pids = JSON.stringify(this.productIds);
				
				if (wiredata.length === retrievedata.length && prodids === pids) {
					
					this.lstTask = retrievedata;
				} else {
					
					this.lstTask = retrievedata;
				}
			} else {
				
				this.lstTask = JSON.parse(data);
			}
			this.selectedTasks = JSON.stringify(this.lstTask);
		}).catch((error) => {
			this.error = error;
		});
	}
	handleTaskChange(event) {
		var taskId = event.currentTarget.dataset.id;
		var checkBoxValue = event.target.checked;
		for (var i = 0; i < this.lstTask[taskId].products.length; i++) {
			this.lstTask[taskId].products[i].isChecked = checkBoxValue;
		}
		this.lstTask[taskId].isChecked = checkBoxValue;
		this.selectedTasks = JSON.stringify(this.lstTask);
	}
	handleProductChange(event) {
		
		var taskId = event.currentTarget.dataset.id;
		var productId = event.currentTarget.dataset.value;
		var checkBoxValue = event.target.checked;
		var isDiffer = false;
		if (checkBoxValue) {
			this.lstTask[taskId].products[productId].isChecked = checkBoxValue;
			this.lstTask[taskId].isChecked = checkBoxValue;
		} else {
			this.lstTask[taskId].products[productId].isChecked = checkBoxValue;
			for (var i = 0; i < this.lstTask[taskId].products.length; i++) {
				//If any product is checked then dont uncheck task.
				if (this.lstTask[taskId].products[i].isChecked) {
					isDiffer = true;
					break;
				}
			}
			if (!isDiffer) {
				this.lstTask[taskId].isChecked = checkBoxValue;
			}
		}
		this.selectedTasks = JSON.stringify(this.lstTask);
	}
	@api
	validate() {
		sessionStorage.setItem('taskJson', JSON.stringify(this.lstTask));
		sessionStorage.setItem('taskProducts', JSON.stringify(this.productIds));
		return {
			isValid: true
		};
	}
}