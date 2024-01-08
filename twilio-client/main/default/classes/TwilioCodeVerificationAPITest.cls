/**
 * @description Twilio Code Verification API Test
 * @author Jun
 */
@IsTest(IsParallel=true)
public with sharing class TwilioCodeVerificationAPITest {
  @IsTest
  static void testShouldThrowExceptionForDeveloperError() {
    TwilioCodeVerificationAPI api = new TwilioCodeVerificationAPI();
    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      try {
        api.body(new Map<String, Object>{});
        Assert.fail('this should throw an excetion');
      } catch (Exception e) {
        Assert.isInstanceOfType(e, System.IllegalArgumentException.class);
      }
      try {
        api.body(new Map<String, Object>{ 'randomKey' => '+12222222222' });
        Assert.fail('this should throw an exception');
      } catch (Exception e) {
        Assert.isInstanceOfType(e, System.IllegalArgumentException.class);
      }
      Assert.areEqual(
        JSON.serialize(
          new Map<String, Object>{
            'phoneNumber' => '+12222222222',
            'code' => '123456'
          }
        ),
        api.body(
          new Map<String, Object>{
            'phoneNumber' => '+12222222222',
            'code' => '123456'
          }
        )
      );
    }
    Test.stopTest();
  }

  @IsTest
  static void testResponseProcessingForDevelopers() {
    TwilioCodeVerificationAPI api = new TwilioCodeVerificationAPI();
    System.HttpResponse resp = new System.HttpResponse();
    resp.setStatusCode(500);
    System.HttpResponse successResponse = new System.HttpResponse();
    successResponse.setStatusCode(200);
    successResponse.setBody('success');
    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      try {
        api.handleResponse(resp);
        Assert.fail('Should encounter an exception');
      } catch (Exception e) {
        Assert.isInstanceOfType(
          e,
          TwilioCodeVerificationAPI.APIException.class
        );
      }
      try {
        api.handleResponse(successResponse);
      } catch (Exception e) {
        Assert.fail('should not encounter an exception');
      }
    }
    Test.stopTest();
  }

  @IsTest
  static void testConstants() {
    TwilioCodeVerificationAPI api = new TwilioCodeVerificationAPI();
    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserid())) {
      // for mutation
      Assert.areEqual(
        'callout:twilio_verify/verificationCheck',
        api.calloutEndpoint()
      );
      Assert.areEqual('POST', api.calloutMethod());
    }
    Test.stopTest();
  }
}
