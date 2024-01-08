/**
 * @description Twilio Create Verification API Hook
 * @author Jun
 */
public with sharing class TwilioCreateVerificationAPI extends TwilioAPI {
  @TestVisible
  protected override String calloutEndpoint() {
    return 'callout:twilio_verify/createVerification';
  }
  @TestVisible
  protected override String calloutMethod() {
    return 'POST';
  }

  /**
   * @description
   * @param arguments
   *  phoneNumber -> +1xxxyyyzzzz
   * @return  `String`
   */
  @TestVisible
  protected override String body(Map<String, Object> arguments) {
    if (!arguments.containsKey('phoneNumber')) {
      throw new System.IllegalArgumentException('phoneNumber is required');
    }
    return JSON.serialize(arguments);
  }

  @TestVisible
  protected override String handleResponse(System.HttpResponse response) {
    if (response.getStatusCode() != 200) {
      throw new APIException('Did not succeed');
    }
    return response.getBody();
  }

  /**
   * @description Twilio Create Verification Exception
   */
  public class APIException extends Exception {
  }
}
