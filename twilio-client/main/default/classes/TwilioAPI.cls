/**
 * @description api callout
 * @author Jun
 */
public abstract class TwilioAPI {
  /**
   * @description calls the underlying api service with a parameter and configured client
   * @param arguments
   * @return  `String`
   */
  public String callService(Map<String, Object> arguments) {
    HttpRequest request = new HttpRequest();
    request.setEndpoint(this.calloutEndpoint());
    request.setMethod(this.calloutMethod());
    request.setBody(this.body(arguments));
    HttpResponse response = new Http().send(request);
    return this.handleResponse(response);
  }

  protected abstract String calloutMethod();

  protected abstract String calloutEndpoint();

  protected abstract String body(Map<String, Object> arguments);

  protected abstract String handleResponse(System.HttpResponse response);
}
