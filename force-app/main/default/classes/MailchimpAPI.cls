global class MailchimpAPI {

    private static final String USER_AGENT = 'Mailchimp Apex Lib';
    private static final String URL_TEMPLATE = 'https://{0}.api.mailchimp.com/3.0';

    private final String BASE_URL;
    private final String API_KEY;
    private final String SERVER;

    /**
     * Mailchimp exception
     *
     * https://mailchimp.com/developer/marketing/docs/errors/
     */
    public class MailchimpException extends Exception {
        String type;
        String title;
        Integer statusCode;
        String detail;
        String instance;
    }

    public MailchimpAPI(String apiKey) {
        this(apiKey.split('-')[0], apiKey.split('-')[1]);
    }

    public MailchimpAPI(String apiKey, String server) {
        API_KEY = apiKey;
        SERVER = server;
        BASE_URL = String.format(URL_TEMPLATE, new String[]{ SERVER });
    }

    public String ping() {
        return MailchimpObject.parse(executeRequest('GET', '/ping')).getString('health_status');
    }

    public MailchimpObject getLists() {
        return MailchimpObject.parse(executeRequest('GET', '/lists'));
    }

    /**
     * MEMBER NOTES /lists/{list_id}/members/{subscriber_hash}/notes
     */

    private class MailchimpNoteJSON {
        String note;

        public MailchimpNoteJSON(String note) {
            this.note = note;
        }
    }


    public MailchimpObject getNotes(String listId, String email) {
        return MailchimpObject.parse(executeRequest(
            'GET',
            String.format('/lists/{0}/members/{1}/notes', new String[]{
                listId,
                getSubscriberHash(email)
            }),
            new Map<String, String>{'sort_field' => 'created_at'}
        ));
    }

    public void addNote(String listId, String email, String note) {
        executeRequest(
            'POST',
            String.format('/lists/{0}/members/{1}/notes', new String[]{
                listId,
                getSubscriberHash(email)
            }),
            System.JSON.serialize(new MailchimpNoteJSON(note))
        );
    }

    /**
     * TAG SEARCH /lists/{list_id}/tag-search
     */

    public MailchimpObject getTags(String listId) {
        return MailchimpObject.parse(executeRequest(
            'GET',
            String.format('/lists/{0}/tag-search', new String[]{
                listId
            })
        ));
    }

    public MailchimpObject tagSearch(String listId, String search) {
        return MailchimpObject.parse(executeRequest(
            'GET',
            String.format('/lists/{0}/tag-search', new String[]{
                listId
            }),
            new Map<String, String>{
                'name' => search
            }
        ));
    }

    /**
     * MEMBER TAGS /lists/{list_id}/members/{subscriber_hash}/tags
     */

    public MailchimpObject getTags(String listId, String email) {
        return MailchimpObject.parse(executeRequest(
            'GET',
            String.format('/lists/{0}/members/{1}/tags', new String[]{
                listId,
                getSubscriberHash(email)
            })
        ));
    }


    private class MailchimpTagJSON {
        String name;
        String status;

        public MailchimpTagJSON(String name, String status) {
            this.name = name;
            this.status = status;
        }
    }

    private static MailchimpTagJSON[] mailchimpTagsFromList(String[] tags, String status) {
        MailchimpTagJSON[] collection = new List<MailchimpTagJSON>();

        for (String tag : tags) {
            collection.add(new MailchimpTagJSON(tag, status));
        }

        return collection;
    }

    public void addTag(String listId, String subsciberHash, String tag) {
        addTags(listId, subsciberHash, new List<String>{ tag });
    }

    public void addTags(String listId, String email, List<String> tags) {
        executeRequest(
            'POST',
            String.format('/lists/{0}/members/{1}/tags', new String[]{
                listId,
                getSubscriberHash(email)
            }),
            System.JSON.serialize(mailchimpTagsFromList(tags, 'active'))
        );
    }

    public void removeTag(String listId, String email, String tag) {
        removeTags(listId, email, new List<String>{ tag });
    }

    public void removeTags(String listId, String email, List<String> tags) {
        executeRequest(
            'POST',
            String.format('/lists/{0}/members/{1}/tags', new String[]{
                listId,
                getSubscriberHash(email)
            }),
            System.JSON.serialize(mailchimpTagsFromList(tags, 'inactive'))
        );
    }

    /**
     * Members /lists/{list_id}/members
     */

    public void addMember(String listId, MailchimpSubscriber subscriber) {
        executeRequest(
            'POST',
            String.format('/lists/{0}/members', new String[]{
                listId
            }),
            subscriber.toString()
        );
    }

    public MailchimpObject getMember(String listId, String email) {
        return MailchimpObject.parse(executeRequest(
            'GET',
            String.format('/lists/{0}/members/{1}', new String[]{
                listId,
                getSubscriberHash(email)
            })
        ));
    }

    public MailchimpObject addOrUpdateMember(String listId, String email, MailchimpSubscriber subscriber) {
        return MailchimpObject.parse(executeRequest(
            'PUT',
            String.format('/lists/{0}/members/{1}', new String[]{
                listId,
                getSubscriberHash(email)
            })
        ));
    }

    public void updateMember(String listId, String email, MailchimpSubscriber subscriber) {
        executeRequest(
            'PATCH',
            String.format('/lists/{0}/members/{1}', new String[]{
                listId,
                getSubscriberHash(email)
            })
        );
    }

    public void archiveMember(String listId, String email) {
        executeRequest(
            'DELETE',
            String.format('/lists/{0}/members/{1}', new String[]{
                listId,
                getSubscriberHash(email)
            })
        );
    }

    /**
     * Delete all personally identifiable information related to a list member,
     * and remove them from a list. This will make it impossible to re-import
     * the list member.
     */
    public void deleteMember(String listId, String email) {
        executeRequest(
            'POST',
            String.format('/lists/{0}/members/{1}/actions/delete-permanent', new String[]{
                listId,
                getSubscriberHash(email)
            })
        );
    }

    /**
     * EVENTS /lists/{list_id}/members/{subscriber_hash}/events
     */
    public MailchimpObject getEvents(String listId, String email) {
        return MailchimpObject.parse(executeRequest(
            'GET',
            String.format('/lists/{0}/members/{1}/events', new String[]{
                listId,
                getSubscriberHash(email)
            })
        ));
    }

    private class MailchimpEventJSON {
        /** The name for this type of event ('purchased', 'visited', etc). Must be 2-30 characters in length  */
        String name;
        Object properties;
        /** Events created with the is_syncing value set to true will not trigger automations.  */
        Boolean is_syncing;
        String occurred_at;

        MailchimpEventJSON(String name, Object properties) {
            this.name = name;
            this.properties = properties;

            is_syncing = false;
            occurred_at = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
        }
    }

    public void addEvent(String listId, String email, String name, Object properties) {
        executeRequest(
            'POST',
            String.format('/lists/{0}/members/{1}/events', new String[]{
                listId,
                getSubscriberHash(email)
            }),
            System.JSON.serialize(new MailchimpEventJSON(name, properties))
        );
    }

    /**
     * INTEREST CATEGORIES /lists/{list_id}/interest-categories
     */

    public MailchimpObject getInterestCategories(String listId) {
        return MailchimpObject.parse(executeRequest(
            'GET',
            String.format('/lists/{list_id}/interest-categories', new String[]{
                listId
            })
        ));
    }

    /**
     * -- END
     */

    /**
     * Subscriber hash is the MD5 hash of the lowercase version of the list member's email address.
     */
    private static String getSubscriberHash(String email) {
        String requestInput = email.toLowerCase();

        Blob requestBlob = Blob.valueOf(requestInput);
        Blob hash = Crypto.generateDigest('MD5', requestBlob);

        return EncodingUtil.convertToHex(hash);
    }

    private HttpResponse executeRequest(String method, String requestUri) {
        return executeRequest(method, requestUri, new Map<String, String>(), '');
    }

    private HttpResponse executeRequest(String method, String requestUri, Map<String, String> queryParams) {
        return executeRequest(method, requestUri, queryParams, '');
    }

    private HttpResponse executeRequest(String method, String requestUri, String requestBody) {
        return executeRequest(method, requestUri, new Map<String, String>(), requestBody);
    }

    private HttpResponse executeRequest(
        String method,
        String requestUri,
        Map<String, String> queryParams,
        String requestBody
    ) {
        HttpRequest req = new HttpRequest();

        req.setMethod(method);
        req.setEndpoint(BASE_URL + addQueryParams(requestUri, queryParams));

        addHeaders(req);

        if (!String.isEmpty(requestBody)) {
            req.setBody(requestBody);
        }

        Http http = new Http();
        HttpResponse res = http.send(req);

        return handleResponse(res);
    }

    private HttpResponse handleResponse(final HttpResponse response) {
        Integer status = response.getStatusCode();

        // Is success:
        if (status >= 200 || status < 400) {
            return response;
        }

        // Parse response to MailchimpError exception:
        throw (MailchimpException)System.JSON.deserialize(response.getBody(), MailchimpException.class);
    }

    private String addQueryParams(String requestUri, Map<String, String> queryParams) {
        List<String> params = new List<String>();

        for (String key : queryParams.keySet()) {
            params.add(key + '=' + queryParams.get(key));
        }

        if (!params.isEmpty()) {
            return requestUri + '?' + String.join(params, '&');
        }

        return requestUri;
    }

    private void addHeaders(HttpRequest req) {
        req.setHeader('User-Agent', USER_AGENT);

        Blob headerValue = Blob.valueOf('APEX' + ':' + API_KEY);
        String authorizationHeader = 'Basic ' +
        EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
    }

}
