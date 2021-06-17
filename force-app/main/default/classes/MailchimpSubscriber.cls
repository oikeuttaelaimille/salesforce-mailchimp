/**
 * Builder pattern for mailchimp subsriber request
 */
public class MailchimpSubscriber {
    public enum Status {
        subscribed,
        unsubscribed,
        cleaned,
        pending,
        transactional
    }

    private String email;

    public MailchimpSubscriber(String email) {
        this.email = email;
    }

    public String getEmail() {
        return email;
    }

    private Status status;
    private Status status_if_new;

    public MailchimpSubscriber setStatus(Status status) {
        this.status = status;
        return this;
    }

    public MailchimpSubscriber setStatusIfNew(Status status_if_new) {
        this.status_if_new = status_if_new;
        return this;
    }

    private String email_type;

    public MailchimpSubscriber setEmailType(String email_type) {
        this.email_type = email_type;
        return this;
    }

    private Map<String, String> mergeFields;

    public MailchimpSubscriber addMergeField(String key, String value) {
        if (mergeFields == null) {
            mergeFields = new Map<String, String>();
        }

        mergeFields.put(key, value);
        return this;
    }

    private Map<String, String> interests;

    public MailchimpSubscriber addInterests(String key, String value) {
        if (interests == null) {
            interests = new Map<String, String>();
        }

        interests.put(key, value);
        return this;
    }

    private String language;

    public MailchimpSubscriber setLanguage(String language) {
        this.language = language;
        return this;
    }

    private Boolean vip;

    public MailchimpSubscriber setVIP(Boolean vip) {
        this.vip = vip;
        return this;
    }

    private class Location {
        Decimal latitude;
        Decimal longitude;

        public Location(Decimal latitude, Decimal longitude) {
            this.latitude = latitude;
            this.longitude = longitude;
        }

    }

    private Location location;

    public MailchimpSubscriber setLocation(Decimal latitude, Decimal longitude) {
        this.location = new Location(latitude, longitude);
        return this;
    }

    private class MarketingPermission {
        String marketing_permission_id;
        Boolean enabled;

        public MarketingPermission(String marketing_permission_id, Boolean enabled) {
            this.marketing_permission_id = marketing_permission_id;
            this.enabled = enabled;
        }
    }

    private MarketingPermission marketing_permissions;

    public MailchimpSubscriber setMarketingPermissions(String marketing_permission_id, Boolean enabled) {
        this.marketing_permissions = new MarketingPermission(marketing_permission_id, enabled);
        return this;
    }

    private String ip_signup;

    /**
     * IP address the subscriber signed up from.
     */
    public MailchimpSubscriber setSignupIP(String ip_signup) {
        this.ip_signup = ip_signup;
        return this;
    }

    private String timestamp_signup;

    /**
     * The date and time the subscriber signed up for the list in ISO 8601 format.
     */
    public MailchimpSubscriber setSingupTimestamp(String timestamp_signup) {
        this.timestamp_signup = timestamp_signup;
        return this;
    }

    private String ip_opt;

    /**
     * The IP address the subscriber used to confirm their opt-in status.
     */
    public MailchimpSubscriber setOptIP(String ip_opt) {
        this.ip_opt = ip_opt;
        return this;
    }

    private String timestamp_opt;

    public MailchimpSubscriber setOptTimestamp(String timestamp_opt) {
        this.timestamp_opt = timestamp_opt;
        return this;
    }

    private String[] tags;

    public MailchimpSubscriber addTag(String tag) {
        if (tags == null) {
            tags = new List<String>();
        }

        tags.add(tag);

        return this;
    }

    public override String toString() {
        return System.JSON.serialize(this, true); // Supress null objects;
    }
}
