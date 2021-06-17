/**
 * This class is wrapper around response of JSON.deserializeUntyped.
 */
public class MailchimpObject {

    private final Object data;
    private integer currentIndex;

    private MailchimpObject(Object data) {
        this.data = data;
        this.currentIndex = 0;
    }

    public static MailchimpObject parse(String body) {
        return new MailchimpObject(System.JSON.deserializeUntyped(body));
    }

    public static MailchimpObject parse(final HttpResponse response) {
        return new MailchimpObject(System.JSON.deserializeUntyped(response.getBody()));
    }

    public Boolean isNull() {
        return data == null;
    }

    public Map<String, Object> asMap() {
        return (Map<String, Object>)data;
    }

    public List<Object> asList() {
        return (List<Object>)data;
    }

    public Object asObject() {
        return data;
    }

    public MailchimpObject get(String key) {
        return new MailchimpObject(asMap().get(key));
    }

    public Object getObject(String key) {
        return asMap().get(key);
    }

    public String getString(String key) {
        return (String)asMap().get(key);
    }

    public MailchimpObject getIdx(Integer idx) {
        return new MailchimpObject(getIdxObject(idx));
    }

    public Object getIdxObject(Integer idx) {
        return asList()[idx];
    }

    public override String toString() {
        return System.JSON.serializePretty(this);
    }
}
