@IsTest(IsParallel=true)
public with sharing class TwilioAPITest {
  @IsTest
  static void callServiceSuccess() {
    TwilioAPI api = new TwilioCreateVerificationAPI();
    Test.setMock(System.HttpCalloutMock.class, new SuccessCallout());
    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      String result = api.callService(
        new Map<String, Object>{ 'phoneNumber' => '+12222222222' }
      );
      Assert.areEqual(
        JSON.serialize(new Map<String, String>{ 'status' => 'pending' }),
        result
      );
    }
    Test.stopTest();
  }

  @IsTest
  static void callServiceFailure() {
    TwilioAPI api = new TwilioCreateVerificationAPI();
    Test.setMock(System.HttpCalloutMock.class, new NetworkError());
    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      try {
        api.callService(
          new Map<String, Object>{ 'phoneNumber' => '+12222222222' }
        );
        Assert.fail('Should not succeed');
      } catch (Exception e) {
        Assert.isInstanceOfType(
          e,
          TwilioCreateVerificationAPI.APIException.class
        );
      }
    }
    Test.stopTest();
  }

  private class SuccessCallout implements System.HttpCalloutMock {
    /**
     * @description responds with a success
     * @param request
     * @return  `System.HttpResponse`
     */
    public System.HttpResponse respond(System.HttpRequest request) {
      System.HttpResponse resp = new System.HttpResponse();
      resp.setStatus('Ok');
      resp.setBody(
        JSON.serialize(new Map<String, String>{ 'status' => 'pending' })
      );
      resp.setStatusCode(200);
      return resp;
    }
  }

  private class NetworkError implements System.HttpCalloutMock {
    /**
     * @description responds with a failure
     * @param request
     * @return  `System.HttpResponse`
     */
    public System.HttpResponse respond(System.HttpRequest request) {
      System.HttpResponse resp = new System.HttpResponse();
      resp.setStatus('Failed');
      resp.setBody(
        JSON.serialize(new Map<String, String>{ 'status' => 'rejected' })
      );
      resp.setStatusCode(500);
      return resp;
    }
  }
}
