import { LightningElement, api }
from 'lwc';

export default class Erp_checkboxgroup extends LightningElement {
	@api value = [];
	@api availableOptions = [];
	@api label = '';
	@api selectedOptions = '';
	@api selectedProducts;
	data = [];
	@api userRole = '';
	initialValue = [];
	showHelptext = false;

	get options() {
		this.data = JSON.parse(this.availableOptions);
		return this.data;
	}

	connectedCallback() {
		//This logic is for Edit flow to populate selectedOptions
		let tempArray = [];
		
		let tempData = JSON.parse(this.availableOptions);
		for (var i = 0; i < this.value.length; i++) {
			let option = tempData.find(obj => obj.value == this.value[i]).label;
			tempArray.push(option);
		}
		this.selectedOptions = tempArray.join(', ');
		this.initialValue = this.value;
		if (this.userRole === 'District Installation Manager') {
			this.showHelptext = true;
		}
	}

	handleChange(e) {
		this.value = e.detail.value;
		if (this.userRole === 'District Installation Manager') {
			console.log("inside");
			let isHDEProduct = false;
			let tempData = JSON.parse(this.availableOptions);
			// initValue variable having the preselected values
			let initValue = this.initialValue;
			if (initValue.length < this.value.length) {
				for (let i of this.value) {
					let isFound = initValue.find(obj => obj === i);
					if (!isFound) { // !isFound means it is the new product
						let option = tempData.find(obj => obj.value == i).family;
						if (option === 'HDE') {
							isHDEProduct = true;
						}
						if (isHDEProduct) {
							for (let j of tempData) {
								if (j.family === 'HDE') {
									let isExist = this.value.find(obj => obj === j.value);
									if (!isExist) {
										this.value.push(j.value);
									}
								}
							}
						}
					}
				}
			} else if (initValue.length > this.value.length) {
				for (let i of initValue) {
					let isFound = this.value.find(obj => obj === i);
					if (!isFound) { // !isFound means it is the new product
						let option = tempData.find(obj => obj.value == i).family;
						if (option === 'HDE') {
							isHDEProduct = true;
							if (isHDEProduct) {
								for (let j of tempData) {
									if (j.family === 'HDE') {
										let isExist = this.value.find(obj => obj === j.value);
										if (isExist) {
											const index = this.value.indexOf(j.value);
											if (index > -1) {
												this.value.splice(index, 1);
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		this.initialValue = this.value;
		let tempArray = [];
		for (var i = 0; i < this.value.length; i++) {
			let option = this.data.find(obj => obj.value == this.value[i]).label;
			tempArray.push(option);
		}
		this.selectedOptions = tempArray.join(';');
	}

	@api
	validate() {
		if (typeof this.value !== 'undefined' && this.value.length > 0) {
			return {
				isValid: true
			};
		} else {
			return {
				isValid: false,
				errorMessage: 'Please select a choice.'
			};
		}
	}
}