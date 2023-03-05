/* eslint-disable @lwc/lwc/no-api-reassignments */
import { LightningElement, api } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import CustomDataTableResource from '@salesforce/resourceUrl/CustomDataTable';

export default class DatatablePicklist extends LightningElement {
    @api label;
    @api placeholder;
    @api options;
    @api value;
    @api context;
    @api variant;
    @api name;
    showPicklist = false;
    picklistValueChanged = false;
  //loads the custom CSS for picklist custom type on lightning datatable
  renderedCallback() {
    Promise.all([
        loadStyle(this, CustomDataTableResource),
    ]).then(() => { });
    }

    get picklistOptions() {
        if (this.options) {
            return this.options.map((vals) => {
                return {
                    ...vals,
                    selected:
                        vals.value === this.value ? true : false
                };
            });
        }
        return [];
    }

    handleSelect(event) {

        this.value = event.target.value;

        this.dispatchEvent(new CustomEvent('picklistchanged', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                data: { context: this.context, value: this.value, name: this.name}
            }
        }));

    }
}