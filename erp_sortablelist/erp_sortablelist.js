/* global jquery */
import { LightningElement, track, api } from 'lwc';

export default class Erp_sortablelist extends LightningElement {

    selectedRows = [];
    columns = [
        { label: 'Name', fieldName: 'name' },
        { label: 'Priority', fieldName: 'priority' }
    ];

    data = [
        { id: 'a1MJ0000004g5SBMAY', name: 'Northeast Install', priority: '1' },
        { id: 'a1MJ0000004g5SCMAY', name: 'South Install', priority: '2' },
        { id: 'a1MJ0000004g5SDMAY', name: 'Midwest Install', priority: '3' },
        { id: 'a1MJ0000004g5SEMAY', name: 'West Install', priority: '4' }
    ];

    handleRowAction(event) {
        console.log(JSON.stringify(event.detail.action));
        var rowIndex = this.data.findIndex(row => row.id === event.detail.row.id);
        //this.data = [...this.data ,{ id:'a1MJ0000004g5SEMA', name: 'West', priority: '5' }];
        let tempData = this.data;
        if (event.detail.action.name === 'up_button') {
            console.log('clicked FIRST button');

            tempData = this.moveArrayItemToNewIndex(tempData, rowIndex, rowIndex - 1);

        } else if (event.detail.action.name === 'down_button') {
            console.log('clicked SECOND button');
            tempData = this.moveArrayItemToNewIndex(tempData, rowIndex, rowIndex + 1);
        }
        //this.data = [];  
        for (var idx = 0; idx < tempData.length; idx++) {
            tempData[idx].priority = idx + 1;
        }
        this.data = [...tempData];
    }

    moveArrayItemToNewIndex(arr, old_index, new_index) {
        if (new_index >= arr.length) {
            var k = new_index - arr.length + 1;
            while (k--) {
                arr.push(undefined);
            }
        }
        arr.splice(new_index, 0, arr.splice(old_index, 1)[0]);
        return arr;
    };


    get rowData() {
        console.log(this.data);
        return this.data;
    }

    handleUpClick(event) {
        console.log(this.selectedRows);
        var el = this.template.querySelector('lightning-datatable');
        console.log(el);
        var selected = el.getSelectedRows();
        var rowIndex = this.data.findIndex(row => row.id === selected[0].id);
        let tempData = this.data;
        tempData = this.moveArrayItemToNewIndex(tempData, rowIndex, rowIndex - 1);
        for (var idx = 0; idx < tempData.length; idx++) {
            tempData[idx].priority = idx + 1;
        }
        this.data = [...tempData];
    }

    handleDownClick(event) {
        console.log(this.selectedRows);
        var el = this.template.querySelector('lightning-datatable');
        console.log(el);
        var selected = el.getSelectedRows();
        var rowIndex = this.data.findIndex(row => row.id === selected[0].id);
        let tempData = this.data;
        tempData = this.moveArrayItemToNewIndex(tempData, rowIndex, rowIndex + 1);
        for (var idx = 0; idx < tempData.length; idx++) {
            tempData[idx].priority = idx + 1;
        }
        this.data = [...tempData];
    }
}