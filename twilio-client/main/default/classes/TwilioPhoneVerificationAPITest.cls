/**
 * @description Tests for TwilioPhoneVerificationAPI
 * @author Jun
 */
@IsTest(IsParallel=true)
public with sharing class TwilioPhoneVerificationAPITest {
  @IsTest
  static void testCreatePhoneVerificationWithDifferentNumbers() {
    Mock createPVApiMock = Mock.forType(TwilioAPI.class);

    MethodSpy pvSpy = createPVApiMock.spyOn('callService');

    String successResult = JSON.serialize(
      new Map<String, Object>{ 'status' => 'success' }
    );
    pvSpy.whenCalledWith(
        new Map<String, Object>{ 'phoneNumber' => '+12222222222' }
      )
      .thenReturn(successResult);

    pvSpy.whenCalledWith(new Map<String, Object>{ 'phoneNumber' => '' })
      .thenThrow(
        new TwilioCreateVerificationAPI.APIException('phone is required')
      );

    TwilioPhoneVerificationAPI service = new TwilioPhoneVerificationAPI();
    service.createApi = (TwilioAPI) createPVApiMock.stub;
    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      String executionResult = service.createVerification('+12222222222');
      Assert.areEqual(successResult, executionResult);
      Expect.that(pvSpy).hasBeenCalledTimes(1);

      try {
        service.createVerification('');
        Assert.fail('should encounter an exception');
      } catch (Exception e) {
        Assert.isInstanceOfType(
          e,
          TwilioCreateVerificationAPI.APIException.class
        );
      }
      Expect.that(pvSpy).hasBeenCalledTimes(2);
    }
    Test.stopTest();
  }

  @IsTest
  static void testVerifiyCodeWithDifferentNumberAndCode() {
    Mock verifyCodeMock = Mock.forType(TwilioAPI.class);

    MethodSpy vcSpy = verifyCodeMock.spyOn('callService');

    String successResult = JSON.serialize(
      new Map<String, Object>{ 'status' => 'success' }
    );
    vcSpy.whenCalledWith(
        new Map<String, Object>{
          'phoneNumber' => '+12222222222',
          'code' => '123456'
        }
      )
      .thenReturn(successResult);

    String failResult = JSON.serialize(
      new Map<String, String>{ 'status' => 'rejected' }
    );
    vcSpy.whenCalledWith(
        new Map<String, Object>{
          'phoneNumber' => '+12222222222',
          'code' => '000000'
        }
      )
      .thenReturn(failResult);

    TwilioPhoneVerificationAPI service = new TwilioPhoneVerificationAPI();
    service.codeApi = (TwilioAPI) verifyCodeMock.stub;
    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      String executionResult = service.verificationCheck(
        '+12222222222',
        '123456'
      );
      Assert.areEqual(successResult, executionResult);
      String failExecutionResult = service.verificationCheck(
        '+12222222222',
        '000000'
      );
      Assert.areEqual(failResult, failExecutionResult);
      Expect.that(vcSpy).hasBeenCalledTimes(2);
    }
    Test.stopTest();
  }
}
