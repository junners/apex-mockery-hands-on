import { LightningElement, api, wire } from "lwc";
import { getRecord, updateRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import startPhoneVerification from "@salesforce/apex/PhoneVerificationService.startPhoneVerification";
import closePhoneVerification from "@salesforce/apex/PhoneVerificationService.closePhoneVerification";

const fields = ["Contact.Phone", "Contact.Phone_Verified__c"];

export default class PhoneVerification extends LightningElement {
  @api recordId;

  phone;
  isLoaded = false;

  showCodeComponent = false;

  @wire(getRecord, { recordId: "$recordId", fields })
  preloadAction({ error, data }) {
    if (data && !error) {
      this.isLoaded = true;
      this.phone = data.fields.Phone.value;
    }
  }

  async callout(apexMethod) {
    let result, error;
    try {
      result = await apexMethod;
    } catch (e) {
      error = e;
    }
    return [result, error];
  }

  async handlePhoneVerificationCode(event) {
    const [result, error] = await this.callout(
      startPhoneVerification({ phoneNumber: this.phone })
    );
    if (error && !result) {
      this.showError(event);
      return;
    }
    this.showCodeComponent = true;
    this.dispatchEvent(
      new ShowToastEvent({
        title: "Action Success",
        message: "Successfully sent a verification code to the customer",
        variant: "success"
      })
    );
  }

  async handleCodeSubmission(event) {
    const codeElem = this.refs.verifCode;
    if (!codeElem.checkValidity()) {
      codeElem.reportValidity();
      return;
    }
    const { value: code } = codeElem;
    const [result, error] = await this.callout(
      closePhoneVerification({ phoneNumber: this.phone, code })
    );
    if (error && !result) {
      this.showError(event);
      return;
    }
    const params = { title: result, message: result, variant: "success" };
    if (result !== "approved") {
      params.title = "Wrong Code";
      params.message = `Wrong code, api status is ${result}`;
      params.variant = "error";
      this.dispatchEvent(new ShowToastEvent(params));
      return;
    }

    await this.updateRec(event);
  }

  async updateRec(event) {
    const recordFields = { Phone_Verified__c: true, Id: this.recordId };
    const updateRecordCallout = updateRecord({ fields: recordFields });
    const [result, error] = await this.callout(updateRecordCallout);
    if (error && !result) {
      this.showError(event);
      return;
    }
    const params = { title: result, message: result, variant: "success" };
    this.dispatchEvent(new ShowToastEvent(params));
  }

  showError(event) {
    this.dispatchEvent(
      new ShowToastEvent({
        title: "Cannot Complete action, leave a message to your admin",
        message: "error",
        variant: "error"
      })
    );
    event.stopPropagation();
  }
}
