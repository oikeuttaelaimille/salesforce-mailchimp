public class MailchimpOperation {
  public final String method { get; private set; }
  public final String path {
    get {
      return addQueryParams(path, queryParams);
    }
    private set;
  }
  private Map<String, String> queryParams;
  private Object body;

  public MailchimpOperation(String method, String path) {
    this.method = method.toUpperCase();
    this.path = path;
    this.queryParams = null;
    this.body = null;
  }

  public MailchimpOperation(String method, String path, Object body) {
    this(method, path);
    this.body = body;
  }

  public MailchimpOperation setQueryParams(Map<String, String> queryParams) {
    this.queryParams = queryParams;
    return this;
  }

  public MailchimpOperation addQueryParam(String key, String value) {
    if (this.queryParams == null) {
      this.queryParams = new Map<String, String>();
    }

    this.queryParams.put(key, value);
    return this;
  }

  public MailchimpOperation setBody(Object body) {
    this.body = body;
    return this;
  }

  public Boolean hasBody() {
    return this.body != null;
  }

  public String getBody() {
    if (body == null) {
      return null;
    }

    return System.JSON.serialize(body);
  }

  private static String addQueryParams(
    String requestUri,
    Map<String, String> queryParams
  ) {
    List<String> params = new List<String>();

    if (queryParams != null) {
      for (String key : queryParams.keySet()) {
        params.add(key + '=' + queryParams.get(key));
      }

      if (!params.isEmpty()) {
        return requestUri + '?' + String.join(params, '&');
      }
    }

    return requestUri;
  }
}
