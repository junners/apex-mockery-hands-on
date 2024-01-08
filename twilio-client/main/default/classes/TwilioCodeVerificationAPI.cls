/**
 * @description Code Verification Check for Twilio
 * @author Jun
 */
public with sharing class TwilioCodeVerificationAPI extends TwilioAPI {
  @TestVisible
  protected override String calloutEndpoint() {
    return 'callout:twilio_verify/verificationCheck';
  }
  @TestVisible
  protected override String calloutMethod() {
    return 'POST';
  }

  /**
   * @description constructs payload body
   * @param arguments
   *  phoneNumber -> +1xxxyyyzzzz
   *  code -> six digit number
   * @return  `String`
   */
  @TestVisible
  protected override String body(Map<String, Object> arguments) {
    if (
      !arguments.containsKey('phoneNumber') || !arguments.containsKey('code')
    ) {
      throw new System.IllegalArgumentException(
        'phoneNumber and code are both required'
      );
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
