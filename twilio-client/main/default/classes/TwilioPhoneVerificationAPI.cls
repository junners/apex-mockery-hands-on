/**
 * @description Concretion of twilio api callouts. Twilio Services Are hosted on twilio-services this is designed concretion for a strangler pattern so that the VerificationAPI could be replaced anytime
 * @author Jun
 * @group twilio-api
 */
@NamespaceAccessible
public class TwilioPhoneVerificationAPI implements VerificationAPI {
  @TestVisible
  private TwilioAPI createApi = new TwilioCreateVerificationAPI();

  @TestVisible
  private TwilioAPI codeApi = new TwilioCodeVerificationAPI();

  /**
   * @description creates a phone verification instance
   * @param phoneNumber phone number to verify
   * @return  `String`
   * @exception TwilioCreateVerificationAPIException
   */
  @NamespaceAccessible
  public String createVerification(String phoneNumber) {
    return this.createApi.callService(
      new Map<String, Object>{ 'phoneNumber' => phoneNumber }
    );
  }

  /**
   * @description submits a code for the phone that was trying to be verified
   * @param phoneNumber phone number to verify
   * @param code six digit code
   * @return  `String`
   * @exception TwilioCodeVerificationAPIException
   */
  @NamespaceAccessible
  public String verificationCheck(String phoneNumber, String code) {
    return this.codeApi.callService(
      new Map<String, Object>{ 'phoneNumber' => phoneNumber, 'code' => code }
    );
  }
}
