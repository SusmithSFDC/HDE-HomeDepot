import { LightningElement,api } from 'lwc';
export default class Erp_OCRegionSummary extends LightningElement {
    @api jsonData;
    regionData;
    outputLabel;

    connectedCallback() {
        console.log("++"+JSON.stringify(this.jsonData));
        this.regionData = JSON.parse(this.jsonData);
        var outputRegions = '';
        for(var i=0;i<this.regionData.length;i++){
            var selectedLabels = [];
            console.log('region[i]+'+JSON.stringify(this.regionData[i]));
            console.log('region[i]Reg+'+JSON.stringify(this.regionData[i].selectedRegions));
            for(var j=0;j<this.regionData[i].selectedRegions.length;j++){
                console.log('region[j]+'+JSON.stringify(this.regionData[i].selectedRegions));
                console.log('region[j]2+'+JSON.stringify(this.regionData[i].selectedRegions[j]));
                console.log('this.regionData[i].availableRegions+'+JSON.stringify(this.regionData[i].availableRegions));
                const reg = this.regionData[i].availableRegions.find(element => element.value === this.regionData[i].selectedRegions[j]);
                console.log("reg+"+JSON.stringify(reg));
                selectedLabels.push(reg.label);
                outputRegions += reg.label + ', ';
            }
            this.regionData[i].RegionsLabel = selectedLabels;
        }
    this.outputLabel = outputRegions.slice(0, -2);
    console.log("outputLabel++"+this.outputLabel);
    }
}