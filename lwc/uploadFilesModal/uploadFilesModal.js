import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue  } from 'lightning/uiRecordApi';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class UploadFilesModal extends LightningElement {

    @api recordId;

    @api childFieldName;

    @wire(getRecord, { recordId: '$recordId', layoutTypes: 'Full' })
    record;

    get childFieldId() {
      if(!childFieldName || childFieldName == '') {
        return this.recordId
      }
      return getFieldValue(this.record.data, childFieldName);
    }



    closeModal(){
        this.dispatchEvent(new CustomEvent('selected'));
    }

    handleUploadFinished() {
        // Refresh via window.location
        this.dispatchEvent(
          new ShowToastEvent({
            title: `Success`,
            message: `File(s) have been uploaded`,
            variant: "success"
          })
        );
        this.dispatchEvent(new CustomEvent('selected'));
      }
}