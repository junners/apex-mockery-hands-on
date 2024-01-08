@IsTest(IsParallel=true)
public with sharing class PhoneVerificationServiceTest {
  /**
   * @description Suppression being made due to rule wasn't updated with Expect calls
   */
  @SuppressWarnings('PMD.ApexUnitTestClassShouldHaveAsserts')
  @IsTest
  static void testPhoneVerification() {
    Mock verificationMock = Mock.forType(VerificationAPI.class);

    MethodSpy createVerifSpy = verificationMock.spyOn('createVerification');

    createVerifSpy.whenCalledWith('+12222222222').thenReturn('success');
    createVerifSpy.whenCalledWith('+10000000000').thenReturn('pending');

    MethodSpy verificationCheckSpy = verificationMock.spyOn(
      'verificationCheck'
    );

    verificationCheckSpy.whenCalledWith('+12222222222', '123456')
      .thenReturn('success');
    verificationCheckSpy.whenCalledWith('+12222222222', '000000')
      .thenReturn('pending');
    verificationCheckSpy.whenCalledWith('+10000000000', '000000')
      .thenReturn('pending');

    PhoneVerificationService.verifier = (VerificationAPI) verificationMock.stub;
    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      PhoneVerificationService.startPhoneVerification('+12222222222');
      Expect.that(createVerifSpy).hasbeenCalled();
      Expect.that(verificationCheckSpy).hasNotBeenCalled();
      PhoneVerificationService.startPhoneVerification('+10000000000');
      Expect.that(createVerifSpy).hasBeenCalledTimes(2);
      Expect.that(verificationCheckSpy).hasNotBeenCalled();
      PhoneVerificationService.closePhoneVerification('+12222222222', '123456');
      Expect.that(createVerifSpy).hasBeenCalledTimes(2);
      Expect.that(verificationCheckSpy).hasBeenCalledTimes(1);
    }
    Test.stopTest();
  }
}
