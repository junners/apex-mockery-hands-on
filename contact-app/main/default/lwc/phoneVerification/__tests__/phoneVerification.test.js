import { createElement } from "lwc";
import PhoneVerification from "c/phoneVerification";
import { getRecord } from "lightning/uiRecordApi";

const MOCK_DATA = {
  apiName: "Contact",
  childRelationships: {},
  fields: {
    Id: {
      displayValue: null,
      value: "User User"
    },
    Phone: {
      displayValue: null,
      value: "+12222222222"
    },
    Phone_Verified__c: {
      displayValue: null,
      value: false
    }
  },
  id: "003xx000001X8BdAAK",
  lastModifiedById: "005xx000001X8BdAAK",
  lastModifiedDate: "2022-02-09T08:46:27.000Z",
  recordTypeId: null,
  recordTypeInfo: null,
  systemModstamp: "2022-02-09T08:46:27.000Z"
};

describe("c-phone-verification", () => {
  afterEach(() => {
    // The jsdom instance is shared across test cases in a single file so reset the DOM
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });

  // Helper function to wait until the microtask queue is empty. This is needed for promise
  // timing when calling imperative Apex.
  async function flushPromises() {
    return Promise.resolve();
  }

  describe("getRecord @wire data", () => {
    it("is accessible when records returned", async () => {
      // Create component
      const element = createElement("c-phone-verification", {
        is: PhoneVerification
      });
      document.body.appendChild(element);

      // Emit data from @wire
      getRecord.emit(MOCK_DATA);

      // Wait for any asynchronous DOM updates
      await flushPromises();

      // Check accessibility
      await expect(element).toBeAccessible();
    });
  });
});
