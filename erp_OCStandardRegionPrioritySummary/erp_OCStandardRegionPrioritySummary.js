import { LightningElement,api } from 'lwc';
export default class Erp_OCStandardRegionPrioritySummary extends LightningElement {
    @api regionData;
    @api jsonData;
    
    connectedCallback() {
        this.regionData = JSON.parse(this.jsonData);    
        console.log("check the data value++"+ JSON.stringify(this.regionData));
        for(var i=0;i<this.regionData.length;i++){
            var selectedRegLabel = [];
            for(var j=0;j<this.regionData[i].selectedRegions.length;j++){                
                var regLabel = this.regionData[i].availableRegions.find(data=> data.value === this.regionData[i].selectedRegions[j]);
                if(regLabel != undefined && regLabel != null)
                    selectedRegLabel.push(regLabel.label);
            }
            this.regionData[i].selRegionsLabel = selectedRegLabel;
        }
        console.log("data++"+ JSON.stringify(this.regionData));
    }
}