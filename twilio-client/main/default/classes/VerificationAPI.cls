/**
 * @description Verification api
 * @author Jun
 */
public interface VerificationAPI {
  /**
   * @description creates a phone verification instance
   * @param phoneNumber phone number to verify
   * @return  `String`
   */
  String createVerification(String phoneNumber);

  /**
   * @description submits a code for the phone that was trying to be verified
   * @param phoneNumber phone number to verify
   * @param code six digit code
   * @return  `String`
   */
  String verificationCheck(String phoneNumber, String code);
}
