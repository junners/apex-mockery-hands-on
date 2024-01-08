/**
 * @description Service Class to Invoke Phone Verification
 * @author Jun
 */
public with sharing class PhoneVerificationService {
  @TestVisible
  private static VerificationAPI verifier = new TwilioPhoneVerificationAPI();

  /**
   * @description Starts A phone Verification where a service would send a generated code to the phone number
   * @param phoneNumber
   * @return  `String`
   */
  @AuraEnabled
  public static String startPhoneVerification(String phoneNumber) {
    return verifier.createVerification(phoneNumber);
  }

  /**
   * @description Closes a phone Verification for a number and asks to input the verification code
   * @param phoneNumber
   * @param code
   * @return  `String`
   */
  @AuraEnabled
  public static String closePhoneVerification(String phoneNumber, String code) {
    return verifier.verificationCheck(phoneNumber, code);
  }
}
